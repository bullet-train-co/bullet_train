module FieldsHelper
  def current_fields_form
    @_fields_helper_forms ? @_fields_helper_forms.last : nil
  end

  def with_field_settings(options)
    @_fields_helper_forms ||= []

    if options[:form]
      @_fields_helper_forms << options[:form]
    end

    yield

    if options[:form]
      @_fields_helper_forms.pop
    end
  end
end
