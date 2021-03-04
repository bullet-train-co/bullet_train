class Public::HomeController < ApplicationController
  def index
    if ENV['MARKETING_SITE_URL']
      redirect_to ENV['MARKETING_SITE_URL']
    else
      redirect_to new_user_session_path
    end
  end

  def docs
    @file = params[:page].presence || 'index'
    render :docs, layout: 'docs'
  end

  def invitation
    return not_found unless invitation_only?
    return not_found unless params[:key].present?
    return not_found unless invitation_keys.include?(params[:key])
    session[:invitation_key] = params[:key]
    if user_signed_in?
      redirect_to new_account_team_path
    else
      redirect_to new_user_registration_path
    end
  end

  def not_found
    render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
  end
end
