class ScopeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    id_method = "#{attribute}_id".to_sym
    valid_collection = "valid_#{attribute.to_s.pluralize}".to_sym

    if record.send(id_method).present?
      # don't allow users to assign the ids of other teams' or users' resources to this attribute.
      unless record.send(valid_collection).ids.include?(record.send(id_method))
        record.errors.add(id_method, :invalid)
      end
    end
  end
end
