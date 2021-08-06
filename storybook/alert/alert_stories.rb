# frozen_string_literal: true

module Storybook
  class Alert::AlertStories < ActionView::Storybook::Stories
    layout "storybook"
    self.title = "Alert"

    story(:default) do
      controls do
        text(:message, "Example message.")
      end
    end

    story(:error) do
      controls do
        text(:message, "Example message.")
      end
    end

    story(:with_color) do
      controls do
        text(:message, "Example message.")
        text(:color, "yellow")
      end
    end
  end
end
