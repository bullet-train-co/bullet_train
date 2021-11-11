module Account::LocaleHelper
  def current_locale
    current_user.locale || current_team.locale || "en"
  end

  # as of now, we only calculate a possessive version of nouns in english.
  # if you're aware of another language where we can do this, please don't hesitate to reach out!
  def possessive_string(string)
    [:en].include?(I18n.locale) ? string.possessive : string
  end

  def model_locales(model)
    name = model.label_string.presence
    return {} unless name

    hash = {}
    prefix = model.class.name.split("::").last.underscore
    hash[:"#{prefix}_name"] = name
    hash[:"#{prefix.pluralize}_possessive"] = possessive_string(name)

    hash
  end

  def models_locales(*models)
    hash = {}
    models.compact.each do |model|
      hash.merge! model_locales(model)
    end
    hash
  end

  # this is a bit scary, no?
  def account_controller?
    controller.class.name.match(/^Account::/)
  end

  def t(key, options = {})
    if account_controller?
      # give preference to the options they've passed in.
      options = models_locales(@child_object, @parent_object).merge(options)
    end
    super(key, options)
  end

  # like 't', but if the key isn't found, it returns nil.
  def ot(key, options = {})
    t(key, options)
  rescue I18n::MissingTranslationData => _
    nil
  end
end
