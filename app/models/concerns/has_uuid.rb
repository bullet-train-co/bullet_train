module HasUuid
  extend ActiveSupport::Concern

  # define relationships.
  included do
    after_initialize do
      self.uuid ||= SecureRandom.hex
    end
  end

  # define class methods.
  module ClassMethods
  end

  # define object methods.
  def short_uuid
    self.uuid.first(7)
  rescue
    "nil"
  end
end
