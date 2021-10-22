module Fields::OptionsSupport
  extend ActiveSupport::Concern

  def assign_checkboxes(strong_params, attribute)
    attribute = attribute.to_s
    if strong_params.dig(attribute).present?
      # filter out the placeholder inputs that arrive along with the form submission.
      strong_params[attribute] = strong_params[attribute].select(&:present?)
    end
  end
end
