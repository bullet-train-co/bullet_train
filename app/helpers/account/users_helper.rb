module Account::UsersHelper

  def profile_photo_for(url: nil, email: nil, first_name: nil, last_name: nil)
    if cloudinary_enabled? && !url.blank?
      cl_image_path(url, width: 100, height: 100, crop: :fill)
    else
      background_color = Colorizer.colorize_similarly(email.to_s, 0.5, 0.6).gsub('#', '')
      return "https://ui-avatars.com/api/?" + {
        color: 'ffffff',
        background: background_color,
        bold: true,
        # email.to_s should not be necessary once we fix the edge case of cancelling an unclaimed membership
        name: [first_name, last_name].join(' ').strip.presence || email,
        size: 200,
      }.to_param
    end
  end

  def user_profile_photo_url(user)
    profile_photo_for(
      url: user.profile_photo_id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name
    )
  end

  def membership_profile_photo_url(membership)
    if membership.user
      user_profile_photo_url(membership.user)
    else
      profile_photo_for(
        url: membership.user_profile_photo_id,
        email: membership.invitation&.email || membership.user_email,
        first_name: membership.user_first_name,
        last_name: membership.user_last_name
      )
    end
  end

  def profile_header_photo_for(url: nil, email: nil, first_name: nil, last_name: nil)
    if cloudinary_enabled? && !url.blank?
      cl_image_path(url, width: 700, height: 200, crop: :fill)
    else
      background_color = Colorizer.colorize_similarly(email.to_s, 0.5, 0.6).gsub('#', '')
      return "https://ui-avatars.com/api/?" + {
        color: 'ffffff',
        background: background_color,
        bold: true,
        # email.to_s should not be necessary once we fix the edge case of cancelling an unclaimed membership
        name: "#{first_name&.first || email.to_s[0]} #{last_name&.first || email.to_s[1]}",
        size: 200,
      }.to_param
    end
  end

  def user_profile_header_photo_url(user)
    profile_header_photo_for(
      url: user.profile_photo_id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name
    )
  end

  def membership_profile_header_photo_url(membership)
    if membership.user
      user_profile_header_photo_url(membership.user)
    else
      profile_header_photo_for(
        url: membership.user_profile_photo_id,
        email: membership.invitation&.email || membership.user_email,
        first_name: membership.user_first_name,
        last_name: membership.user&.last_name || membership.user_last_name
      )
    end
  end


  def current_membership
    current_user.memberships.where(team: current_team).first
  end
end
