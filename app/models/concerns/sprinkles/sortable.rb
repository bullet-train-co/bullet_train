module Sprinkles::Sortable
  extend ActiveSupport::Concern

  # define relationships.
  included do
    scope :in_sort_order, -> { order(:sort_order) }
    before_create do
      self.sort_order ||= (collection.maximum(:sort_order) || -1) + 1
    end
  end

  # define class methods.
  module ClassMethods
  end

  # define object methods.
  def collection
    raise 'you must define `collection` in sortable models.'
  end

end
