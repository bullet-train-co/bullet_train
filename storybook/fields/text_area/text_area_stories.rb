# frozen_string_literal: true

module Storybook
  class Fields::TextArea::TextAreaStories < ActionView::Storybook::Stories
    self.title = "Fields/Text Area"
    layout "storybook"

    story(:default) do
      controls do
        text(:text_area_value, "")
      end
    end

    story(:with_help_text) do
      controls do
        text(:text_area_value, "")
        text(:help_text, "Tell us your deepest, darkest secrets.")
      end
    end

    story(:with_placeholder) do
      controls do
        text(:text_area_value, "")
        text(:placeholder_text, "Your feedback is valuable")
      end
    end

    story(:with_error) do
      controls do
        text(:text_area_value, "Invalid Input")
        error_text "is required"
      end
    end
  end
end
