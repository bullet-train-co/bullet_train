# frozen_string_literal: true

module Storybook
  class Fields::SuperSelect::SuperSelectStories < ActionView::Storybook::Stories
    self.title = "Fields/Super Select"
    layout "storybook"

    story(:default) {}

    story(:multiple) {}

    story(:with_icon) {}
  end
end
