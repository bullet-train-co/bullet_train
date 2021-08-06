# frozen_string_literal: true

module Storybook
  class Button::ButtonStories < ActionView::Storybook::Stories
    self.title = "Button"
    layout "storybook"

    parameters({lang: "markup"})

    story(:button) do
      controls do
        text(:label, "Primary Button")
      end
    end

    story(:button_with_icon) do
      controls do
        text(:label, "Example Button")
        text(:icon, "ti ti-world")
      end
    end

    story(:link) do
      controls do
        text(:label, "Primary Button")
      end
    end

    story(:link_with_icon) do
      controls do
        text(:label, "Example Button")
        text(:icon, "ti ti-world")
      end
    end

    story(:secondary) do
      controls do
        text(:label, "Secondary Button")
      end
    end
  end
end
