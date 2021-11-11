module Fields::DateSupport
  extend ActiveSupport::Concern

  def assign_date(strong_params, attribute)
    attribute = attribute.to_s
    if strong_params.dig(attribute).present?
      parsed_value = Chronic.parse(strong_params[attribute])
      return nil unless parsed_value
      strong_params[attribute] = parsed_value.to_date
    end
  end
end
