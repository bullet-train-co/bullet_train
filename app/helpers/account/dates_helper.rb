module Account::DatesHelper
  # e.g. October 11, 2018
  def display_date(timestamp)
    return nil unless timestamp
    if local_time(timestamp).year == local_time(Time.now).year
      local_time(timestamp).strftime("%B %-d")
    else
      local_time(timestamp).strftime("%B %-d, %Y")
    end
  end

  # e.g. October 11, 2018 at 4:22 PM
  # e.g. Yesterday at 2:12 PM
  # e.g. April 24 at 7:39 AM
  def display_date_and_time(timestamp)
    return nil unless timestamp

    # today?
    if local_time(timestamp).to_date == local_time(Time.now).to_date
      "Today at #{display_time(timestamp)}"
    # yesterday?
    elsif (local_time(timestamp).to_date) == (local_time(Time.now).to_date - 1.day)
      "Yesterday at #{display_time(timestamp)}"
    else
      "#{display_date(timestamp)} at #{display_time(timestamp)}"
    end
  end

  # e.g. 4:22 PM
  def display_time(timestamp)
    local_time(timestamp).strftime("%l:%M %p")
  end

  def local_time(time)
    return time if current_user.time_zone.nil?
    time.in_time_zone(current_user.time_zone)
  end
end
