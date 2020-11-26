module Fields::PhoneFieldHelper
  def display_phone_number(phone_number)
    return nil unless phone_number.present?
    phone_number_parsed = Phonelib.parse(phone_number)
    phone_number_parsed.full_international.gsub(/^\+#{phone_number_parsed.country_code}/, "<span class=\"text-muted\">+#{phone_number_parsed.country_code}</span>").html_safe
  end
end
