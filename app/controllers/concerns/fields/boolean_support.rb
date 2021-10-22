module Fields::BooleanSupport
  extend ActiveSupport::Concern

  def assign_boolean(strong_params, attribute)
    attribute = attribute.to_s
    if strong_params.dig(attribute).present?
      strong_params[attribute] = ActiveModel::Type::Boolean.new.cast(strong_params[attribute]) || false
    end
  end
end
