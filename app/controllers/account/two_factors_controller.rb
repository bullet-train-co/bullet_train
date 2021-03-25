class Account::TwoFactorsController < Account::ApplicationController
  before_action :authenticate_user!

  def create
    @backup_codes = current_user.generate_otp_backup_codes!
    @user = current_user

    current_user.update(
      otp_secret: User.generate_otp_secret,
      otp_required_for_login: true
    )
  end

  def destroy
    @user = current_user
    current_user.update(otp_required_for_login: false)
  end
end
