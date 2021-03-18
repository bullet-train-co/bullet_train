class Account::Oauth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def stripe_connect
    callback("Stripe", team_id_from_env)
  end

  # 🚅 super scaffolding will insert new oauth providers above this line.

  def team_id_from_env
    request.env.dig("omniauth.params", "team_id")&.to_i
  end

  def failure
    flash[:danger] = "Failed to sign in"
    redirect_to root_path
  end

  def callback(class_name, team_id)
    oauth_account_class = "Oauth::#{class_name}Account".constantize
    oauth_accounts_collection = "oauth_#{class_name.underscore}_accounts".to_sym
    oauth_accounts_attribute = "oauth_#{class_name.underscore}_account".to_sym
    integrations_installations_class = "::Integrations::#{class_name}Installation".constantize
    integrations_installations_collection = "integrations_#{class_name.underscore}_installations".to_sym

    auth = request.env["omniauth.auth"]

    # if the user didn't click "authorize" on the providers confirmation page, just show them an error.
    if params[:denied]
      message = t("omniauth.team.denied", provider: t(auth.provider))

      # redirect them to either the integrations page or the registration page.
      path = if team_id
        [:account, team, integrations_installations_collection]
      elsif current_user
        [:account, current_user]
      else
        new_user_registration_path
      end

      redirect_to path, notice: message
    end

    # first, keep a record of the oauth account.
    # this belongs to the system, and sometimes becomes associated with a user.
    begin
      oauth_account = oauth_account_class.find_or_create_by(uid: auth.uid)
      oauth_account.update_from_oauth(auth)
    rescue PG::UniqueViolation
      retry
    end

    # if they're trying to use this account to add an integration to a team.
    if team_id

      # they must be signed in.
      authenticate_user!

      unless (team = current_user.teams.find_by(id: team_id))
        raise "user is adding an integration to a team they don't belong to?"
      end

      # now we check whether they're able to install new integrations for this team.
      if can? :create, integrations_installations_class.new(:team => team, oauth_accounts_attribute => oauth_account)

        # if the oauth account is already present for the team ..
        if team.send(integrations_installations_collection).find_by(oauth_accounts_attribute => oauth_account)
          message = t("omniauth.team.already_present", provider: t(auth.provider))

        else
          # otherwise, create a new integration for this team.
          team.send(integrations_installations_collection).create(:name => oauth_account.name, oauth_accounts_attribute => oauth_account)
          message = t("omniauth.team.connected", provider: t(auth.provider))

        end

      else

        # if they don't have access to add integrations to the team, show them an error.
        message = t("omniauth.team.not_allowed", provider: t(auth.provider))

      end

      # in all of these situations, we take them back to the team's oauth accounts index page for this provider.
      redirect_to [:account, team, integrations_installations_collection], notice: message

    # if they're already signed in, they're trying to add it to their account.
    elsif current_user

      # if the account is already connected to a user, we can't connect it again.
      # this would potentially lock someone else out of their account.
      if oauth_account.user
        message_key = oauth_account.user == current_user ? "omniauth.user.reconnected" : "omniauth.user.already_registered"
        redirect_to edit_account_user_path(current_user), notice: t(message_key, provider: t(auth.provider))
      else
        oauth_account.update(user: current_user)
        redirect_to edit_account_user_path(current_user), notice: t("omniauth.user.connected", provider: t(auth.provider))
      end

    # if they're not trying to add it to a team, they're trying to sign in or sign up.
    # if they're already associated with a user record, just sign them in.
    elsif oauth_account.user

      sign_in oauth_account.user
      handle_outstanding_invitation
      redirect_to account_dashboard_path

    # if they're not associated with a user and they're allowed to sign up.
    elsif show_sign_up_options?

      # we're going to try to create a new user account.
      # if the oauth provider gave us an email address, use that, otherwise use a
      # temporary email placeholder. (we'll never show the temporary to the user.)
      # this has to be a "real" email address so we don't trip up any email validators.
      # however, this is secure because even if someone controlled `bullettrain.co`,
      # they would never be able to guess the hex code to reset the password.
      # even that is a rare edge case, because we force people to update this in onboarding.
      email = auth.info.email.present? ? auth.info.email : "noreply+#{SecureRandom.hex}@bullettrain.co"

      # if the user already exists with the email address on the account ..
      if User.find_by(email: email)

        # we can't sign them in, because they haven't added the oauth account to
        # their account yet for sign in. there is a potential security loophole
        # here if you allow them to do this at worst, and at best you're
        # depending on the security of the oauth provider to have verified the
        # email address on the account.
        redirect_to new_user_session_path(user: {email: email}, email_exists: true), notice: "Sorry, there is already a user registered with the email address #{email}, but this #{t(auth.provider)} account isn't configured for login with that account. Please sign in using your password and then add this account."

      else

        # if the user doesn't exist in the database yet, great!
        # let's create it and sign them in.
        password = Devise.friendly_token[0, 20]
        user = User.create(email: email, password: password, password_confirmation: password)

        oauth_account.update(user: user)

        sign_in user
        handle_outstanding_invitation

        # if the user doesn't have a team at this point, create one.
        unless user.teams.any?
          user.create_default_team

          # if a user is signing up for the first time *and* creating their own team,
          # this is a ux shortcut that makes sense: automatically install their oauth account as an integration.
          user.teams.first.send(integrations_installations_collection).create(:name => oauth_account.name, oauth_accounts_attribute => oauth_account)
        end

        redirect_to account_dashboard_path
      end

    else
      redirect_to new_user_session_path, notice: t("omniauth.user.account_not_found", provider: t(auth.provider))
    end
  end
end
