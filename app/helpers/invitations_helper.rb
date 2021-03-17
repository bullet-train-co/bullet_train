module InvitationsHelper
  def handle_outstanding_invitation
    # was this user registering to claim an invitation?
    if session[:invitation_uuid].present?

      # try to find the invitation, if it still exists.
      invitation = Invitation.find_by_uuid(session[:invitation_uuid])

      # if the invitation was found, claim it for this user.
      invitation&.accept_for(current_user)

      # remove the uuid from the session.
      session.delete(:invitation_uuid)

    end
  end
end
