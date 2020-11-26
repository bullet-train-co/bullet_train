module InvitationOnlyHelper
  def invited?
    session[:invitation_key].present? && invitation_keys.include?(session[:invitation_key])
  end

  def show_sign_up_options?
    return true unless invitation_only?
    invited?
  end
end
