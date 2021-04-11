class SessionsController < Devise::SessionsController
  def pre_otp
    if (@email = params["user"]["email"].downcase.strip.presence)
      @user = User.find_by(email: @email)
    end

    respond_to do |format|
      format.js
    end
  end
end
