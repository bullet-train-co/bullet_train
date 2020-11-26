class Account::Oauth::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def stripe_connect
    team_id = request.env['omniauth.params']['team_id']
    callback(::Oauth::StripeAccount, :oauth_stripe_accounts, team_id ? team_id.to_i : nil)
  end

  # 🚅 super scaffolding will insert new oauth providers above this line.

  def failure
    flash[:danger] = 'Failed to sign in'
    redirect_to root_path
  end

  def callback(oauth_account_class, oauth_accounts_collection, team_id)
    auth = request.env['omniauth.auth']

    # if they're adding this account to a team.
    if team_id

      # they must be signed in.
      authenticate_user!

      # first we check whether they are even a member of the team they're trying to add this account to.
      if team = current_user.teams.find_by(id: team_id)

        # if the user didn't click "authorize" on the providers confirmation page, just show them an error.
        if params[:denied]
          message = "Permission to connect to #{t(auth.provider)} was not granted. Not a problem! You can try again if you want to."

        else

          # if the oauth account is already present for the team ..
          if oauth_account = team.send(oauth_accounts_collection).find_by(uid: auth.uid)

            # update the information we have on file.
            oauth_account.update_from_oauth(auth)
            message = "That #{t(auth.provider)} account is already present for this team!"

          else

            # otherwise, create a new oauth account for this team.
            oauth_account = team.send(oauth_accounts_collection).create(uid: auth.uid)
            oauth_account.update_from_oauth(auth)
            message = "Great! We've added that #{t(auth.provider)} account to your team!"

          end
        end

        # in all of these situations, we take them back to the team's oauth accounts index page for this provider.
        redirect_to [:account, team, oauth_accounts_collection], notice: message
      else

        # unless they don't have access to the team.
        # in that case, we show them an error.
        redirect_to [:account, :dashboard], notice: "You're not allowed to add a #{t(auth.provider)} account to a team you don't have access to."

      end

    # if they're not trying to add it to a team, they're trying to sign in or sign up.
    else

      # check whether this oauth account exists in the database.
      # note: we don't want to pull records that are associated with teams.
      # all the oauth accounts live in the same table, but we don't reuse the records
      # across teams or between a user and the team. this might seem counter-intuitive,
      # but it's a bundle of hurt trying to manage them the other way.
      if oauth_account = oauth_account_class.find_by(team: nil, uid: auth.uid)

        # if it exists, update their info and sign them in.
        oauth_account.update_from_oauth(auth)
        sign_in oauth_account.user
        redirect_to account_dashboard_path

      else

        # otherwise, we're going to try to create a new user account.
        # if the oauth provider gave us an email address, use that, otherwise use a
        # temporary email placeholder. (we'll never show the temporary to the user.)

        # TODO we need to update this to some sort of invalid email address or something
        # people know to ignore. it would be a security problem to have this pointing
        # at anybody's real email address.
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

          oauth_account = user.send(oauth_accounts_collection).create(uid: auth.uid)
          oauth_account.update_from_oauth(auth)

          sign_in user

          # if the user doesn't have a team at this point, create one.
          unless user.teams.any?
            user.create_default_team
          end

          redirect_to account_dashboard_path

        end
      end

    end

  end

end
