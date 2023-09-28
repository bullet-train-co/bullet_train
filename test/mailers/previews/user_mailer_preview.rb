class UserMailerPreview < ActionMailer::Preview
  def welcome
    random_user = User.order(Arel.sql("RANDOM()")).first
    UserMailer.welcome random_user
  end

  def invited
    random_invitation = Invitation.order(Arel.sql("RANDOM()")).first
    UserMailer.invited random_invitation.uuid
  end
end
