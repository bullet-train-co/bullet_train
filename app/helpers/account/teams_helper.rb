module Account::TeamsHelper
  def current_team
    current_user&.current_team
  end

  def other_teams
    return [] unless current_user
    current_user.teams.reject { |team| team == current_user.current_team }
  end

  def users_as_select_options(users, values = [])
    values = [values] unless values.is_a?(Array)
    users.map { |user|
      "<option value=\"#{user.id}\" data-image=\"#{ user_profile_photo_url(user) }\" #{"selected=\"selected\"" if values.include?(user.id)}>#{user.name}</option>"
    }.join.html_safe
  end

  def memberships_as_select_options(memberships, values = [])
    values = [values] unless values.is_a?(Array)
    memberships.map { |membership|
      "<option value=\"#{membership.id}\" data-image=\"#{ membership_profile_photo_url(membership) }\" #{"selected=\"selected\"" if values.include?(membership.id)}>#{membership.name}</option>"
    }.join.html_safe
  end

  def photo_for(object)
    background_color = Colorizer.colorize_similarly((object.name.to_s + object.created_at.to_s).to_s, 0.5, 0.6).gsub('#', '')
    photo = "https://ui-avatars.com/api/?" + {
      color: 'ffffff',
      background: background_color,
      bold: true,
      name: "#{object.name.first}#{object.name.split.one? ? "" : object.name.split.first(2).last.first}",
      size: 200,
    }.to_param
  end

  # TODO this should only be used for certain locales/languages.
  def describe_users_for_user_on_team(users, for_user, team)
    # if this list of users represents everyone on the team, return the team name.
    if (team.users & users) == team.users
      team.name.strip
    else
      ((users - [for_user]) + [for_user]).map do |user|
        if user == for_user
          "You"
        elsif team.users.where("users.first_name ILIKE ?", user.first_name).one?
          user.first_name
        elsif team.users.where("users.first_name ILIKE ? AND LEFT(users.last_name, 1) ILIKE ?", user.first_name, user.last_name.first).one?
          "#{user.first_name} #{user.last_name.first}."
        else
          user.name
        end
      end.to_sentence.strip
    end
  end

  # TODO this should only be used for certain locales/languages.
  def describe_memberships_for_membership_on_team(memberships, for_membership, team)
    # if this list of users represents everyone on the team, return the team name.
    if (team.memberships & memberships) == team.memberships
      team.name.strip
    else
      # place the membership that would be "you" at the end of the array.
      ((memberships - [for_membership]) + [for_membership]).map do |membership|
        if membership == for_membership
          "You"
        elsif membership.first_name.present? && team.memberships.map(&:first_name).select(&:present?).select { |first_name| first_name.downcase == membership.first_name.downcase }.one?
          membership.first_name
        elsif membership.first_name_last_initial.present? && team.memberships.map(&:first_name_last_initial).select { |first_name_last_initial| first_name_last_initial.downcase == membership.first_name_last_initial.downcase }.one?
          membership.user.first_name_last_initial
        else
          membership.full_name
        end
      end.to_sentence.strip
    end
  end

  def can_invite?
    can?(:create, Invitation.new(team: current_team))
  end
end
