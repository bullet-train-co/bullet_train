# frozen_string_literal: true

module Storybook
  class Box::BoxStories < ActionView::Storybook::Stories
    layout "storybook"
    self.title = "Box"

    story(:default) do
      controls do
        text(:title, "Box Title")
        text(:description, "Optional box description.")
        text(:body, "Content body.")
        boolean(:divider, false)
      end
    end
  end
end
