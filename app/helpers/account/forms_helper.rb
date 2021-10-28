module Account::FormsHelper
  PRESENCE_VALIDATORS = [ActiveRecord::Validations::PresenceValidator, ActiveModel::Validations::PresenceValidator]

  def presence_validated?(object, attribute)
    validators = object.class.validators
    validators.select! do |validator|
      PRESENCE_VALIDATORS.include?(validator.class) && validator.attributes.include?(attribute)
    end
    validators.any?
  end

  def flush_content_for(name)
    content_for name, flush: true do
      ""
    end
  end

  def options_with_labels(options, namespace)
    hash = {}
    options.each do |option|
      hash[option] = t([namespace, option].join("."))
    end
    hash
  end

  def if_present(string)
    string.present? ? string : nil
  end

  def id_for(form, method)
    [form.object.class.name, form.index, method].compact.join("_").underscore
  end

  def model_key(form)
    form.object.class.name.pluralize.underscore
  end

  def labels_for(form, method)
    keys = [:placeholder, :label, :help, :options_help]
    path = [model_key(form), (current_fields_namespace || :fields), method].compact
    Struct.new(*keys).new(*keys.map { |key| t((path + [key]).join("."), default: "").presence })
  end

  def options_for(form, method)
    # e.g. "scaffolding/completely_concrete/tangible_things.fields.text_area_value.options"
    path = [model_key(form), (current_fields_namespace || :fields), method, :options]
    t(path.compact.join("."))
  end

  def legacy_label_for(form, method)
    # e.g. 'scaffolding/things.labels.name'
    key = "#{model_key(form)}.labels.#{method}"
    #  e.g. 'scaffolding/things.labels.name' or 'scaffolding.things.labels.name' or nil
    t(key, default: "").presence || t(key.tr("/", "."), default: "").presence
  end

  def within_fields_namespace(namespace)
    @fields_namespaces ||= []
    @fields_namespaces << namespace
    yield
    @fields_namespaces.pop
  end

  def current_fields_namespace
    @fields_namespaces&.last
  end
end
