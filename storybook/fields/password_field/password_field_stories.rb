# frozen_string_literal: true

module Storybook
  class Fields::PasswordField::PasswordFieldStories < ActionView::Storybook::Stories
    self.title = "Fields/Password Field"
    layout "storybook"

    story(:default) do
      controls do
        text(:password_field_value, "")
      end
    end

    story(:with_help_text) do
      controls do
        text(:password_field_value, "")
        text(:help_text, "Stronger passwords are better.")
      end
    end

    story(:with_placeholder) do
      controls do
        text(:password_field_value, "")
        text(:placeholder_text, "5uper$3cret!@")
      end
    end

    story(:with_error) do
      controls do
        text(:password_field_value, "")
        error_text "is required"
      end
    end
  end
end
