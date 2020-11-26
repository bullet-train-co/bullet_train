class Public::HomeController < ApplicationController
  def index
    if ENV['MARKETING_SITE_URL']
      redirect_to ENV['MARKETING_SITE_URL']
    else
      render 'public/home/index', layout: 'public'
    end
  end

  def docs
    raise 'docs are not available in production mode' if Rails.env.production?

    valid_files = [
      'field-partials',
      'field-partials/buttons',
      'field-partials/select',
      'field-partials/super-select',
    ]

    if params[:page].present?
      if valid_files.include?(params[:page])
        @file = params[:page]
      else
        raise 'invalid file'
      end
    else
      @file = 'index'
    end

    @hide_menus = true
    render :docs, layout: 'account'
  end

  def api
    api_key = current_user.try { |cu| cu.api_keys.active.first }
    if api_key
      @live_token = true
      @token = api_key.token
      @secret = "<span>#{helpers.link_to "{{click to reveal}}", "#", onclick: "$(this).parent().text('#{api_key.secret}'); return false;"}</span>".html_safe
    else
      @token = "{{your token}}"
      @secret = "{{your secret}}"
    end
    if user_signed_in?
      @team_id = current_user.current_team.id
    else
      @team_id = "{{team_id}}"
    end
    @hide_menus = true
    render :api, layout: 'account'
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
