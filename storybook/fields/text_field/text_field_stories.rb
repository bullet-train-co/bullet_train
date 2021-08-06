# frozen_string_literal: true

module Storybook
  class Fields::TextField::TextFieldStories < ActionView::Storybook::Stories
    self.title = "Fields/Text Field"
    layout "storybook"

    story(:default) do
      controls do
        text(:text_field_value, "")
      end
    end

    story(:with_help_text) do
      controls do
        text(:text_field_value, "")
        text(:help_text, "Please enter a value.")
      end
    end

    story(:with_error) do
      controls do
        text(:text_field_value, "Invalid Input")
      end
    end

    story(:left_icon) do
      controls do
        text(:text_field_value, "Input with left icon")
      end
    end

    story(:right_icon) do
      controls do
        text(:text_field_value, "Input with Right icon")
      end
    end
  end
end
