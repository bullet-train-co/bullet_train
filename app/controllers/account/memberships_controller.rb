class Account::MembershipsController < Account::ApplicationController
  account_load_and_authorize_resource :membership, :team, member_actions: [:demote, :promote, :reinvite]

  def index
    unless @memberships.count > 0
      redirect_to account_team_invitations_path(@team), notice: I18n.t('memberships.notifications.no_members')
    end
  end

  def show
  end

  def edit
  end

  # PATCH/PUT /account/memberships/:id
  # PATCH/PUT /account/memberships/:id.json
  def update
    respond_to do |format|
      begin
        if @membership.update(membership_params)
          format.html { redirect_to [:account, @membership], notice: I18n.t('memberships.notifications.updated') }
          format.json { render :show, status: :ok, location: [:account, @membership] }
        else
          format.html { render :edit }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      rescue RemovingLastTeamAdminException => exception
        format.html { redirect_to [:account, @team, :memberships], alert: I18n.t('memberships.notifications.cant_demote') }
        format.json { render json: {exception: I18n.t('memberships.notifications.cant_demote')}, status: :unprocessable_entity }
      end
    end
  end

  def demote
    begin
      @membership.membership_roles.find_by(role: Role.admin).try(:destroy)
      redirect_to account_team_memberships_path(@team)
    rescue RemovingLastTeamAdminException => exception
      redirect_to account_team_memberships_path(@team), alert: I18n.t('memberships.notifications.cant_demote')
    end
  end

  def promote
    @membership.roles << Role.admin unless @membership.roles.include?(Role.admin)
    redirect_to account_team_memberships_path(@team)
  end

  def destroy
    # Instead of destroying the membership, we nullify the user_id and use the membership record as a 'Tombstone' for referencing past associations (eg message at-mentions and Scaffolding::CompletelyConcrete::TangibleThings::Assignment)
    begin
      user_was = @membership.user
      @membership.nullify_user

      if user_was == current_user
        # if a user removes themselves from a team, we'll have to send them to their dashboard.
        redirect_to account_dashboard_path, notice: I18n.t('memberships.notifications.you_removed_yourself', team_name: @team.name)
      else
        redirect_to [:account, @team, :memberships], notice: I18n.t('memberships.notifications.destroyed')
      end
    rescue RemovingLastTeamAdminException
      redirect_to account_team_memberships_path(@team), alert: I18n.t('memberships.notifications.cant_remove')
    end
  end

  def reinvite
    @invitation = Invitation.new(membership: @membership, team: @team, email: @membership.user_email, from_membership: current_membership)
    if @invitation.save
      redirect_to [:account, @team, :memberships], notice: I18n.t('account.memberships.notifications.reinvited')
    else
      redirect_to [:account, @team, :memberships], notice: "There was an error creating the invitation (#{@invitation.errors.full_messages.to_sentence})"
    end
  end

  private

    def manageable_role_ids
      helpers.current_membership.manageable_roles.map(&:id)
    end

    # NOTE this method is only designed to work in the context of updating a membership.
    # we don't provide any support for creating memberships other than by an invitation.
    def membership_params

      # we use strong params first.
      strong_params = params.require(:membership).permit(
        :user_first_name,
        :user_last_name,
        :user_profile_photo_id,
        # 🚅 super scaffolding will insert new fields above this line.
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      # after that, we have to be more careful how we update the roles.
      # we can't let users remove roles from a membership that they don't have permission
      # to remove, but we want to allow them to add or remove other roles they do have
      # permission to assign to other team members.
      if params[:membership] && params[:membership][:role_ids].present?

        # first, start with the list of role ids already assigned to this membership.
        existing_role_ids = @membership.role_ids

        # generate a list of role ids we can't allow the current user to remove from this membership.
        existing_role_id_that_are_unmanageable = existing_role_ids - manageable_role_ids

        # now let's ensure the list of role ids from the form only includes ids that they're allowed to assign.
        assignable_role_ids_from_the_form = params[:membership][:role_ids].map(&:to_i) & manageable_role_ids

        # any role ids that are manageable by the current user have to then come from the form data,
        # otherwise we can assume they were removed by being unchecked.
        strong_params[:role_ids] = existing_role_id_that_are_unmanageable + assignable_role_ids_from_the_form

      end

      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end

end
