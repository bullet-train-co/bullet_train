# By default, Rails adds div.field_with_errors wrapper to the form field.
# This initializer removes this wrapper to avoid causing UI issues.
ActionView::Base.field_error_proc = proc do |html_tag|
  html_tag
end
