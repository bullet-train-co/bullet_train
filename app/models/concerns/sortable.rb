module Sortable
  extend ActiveSupport::Concern

  # define relationships.
  included do
    # Yes, everyone hates default scopes, but they for sure make sense here.
    # See the thread at https://twitter.com/andrewculver/status/1405900896664313867?s=20 for more context.
    default_scope -> { order(:sort_order) }

    before_create do
      self.sort_order ||= (collection.maximum(:sort_order) || -1) + 1
    end
  end
end
