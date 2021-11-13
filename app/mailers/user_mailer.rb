class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    @cta_url = account_dashboard_url
    @values = {
      # are there any substitution values you want to include?
    }
    mail(to: @user.email, subject: I18n.t("user_mailer.welcome.subject", **@values))
  end

  # technically not a 'user' email, but they'll be a user soon.
  # didn't seem worth creating an entirely new mailer for.
  def invited(uuid)
    @invitation = Invitation.find_by_uuid uuid
    return if @invitation.nil?
    @cta_url = accept_account_invitation_url(@invitation.uuid)
    @values = {
      # Just in case the inviting user has been removed from the team...
      inviter_name: @invitation.from_membership&.user&.full_name || @invitation.from_membership.name,
      team_name: @invitation.team.name,
    }
    mail(to: @invitation.email, subject: I18n.t("user_mailer.invited.subject", **@values))
  end
end
