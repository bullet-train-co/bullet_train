# frozen_string_literal: true

module Storybook
  class Fields::EmailField::EmailFieldStories < ActionView::Storybook::Stories
    self.title = "Fields/Email Field"
    layout "storybook"

    story(:default) do
      controls do
        text(:email_field_value, "")
      end
    end

    story(:with_help_text) do
      controls do
        text(:email_field_value, "")
        text(:help_text, "We will never spam you, we promise.")
      end
    end

    story(:with_placeholder) do
      controls do
        text(:email_field_value, "")
        text(:placeholder_text, "john.appleseed@example.com")
      end
    end

    story(:with_error) do
      controls do
        text(:email_field_value, "")
        error_text "is required"
      end
    end
  end
end
