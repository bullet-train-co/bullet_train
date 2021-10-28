class Account::Cloudinary::UploadSignaturesController < Account::ApplicationController
  skip_before_action :ensure_onboarding_is_complete_and_set_next_step
  def new
    render plain: Cloudinary::Utils.api_sign_request(upload_signature_params.to_h, Cloudinary.config.api_secret)
  end

  def upload_signature_params
    params.require(:data).permit(:timestamp, :source)
  end
end
