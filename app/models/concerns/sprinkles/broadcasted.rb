class Sprinkles::Broadcaster
  include Singleton

  def initialize
    @level = 0
    @queue = []
  end

  # syntatic sugar.
  def self.batch
    instance.batch do
      yield
    end
  end

  def batch
    @level += 1
    Rails.logger.info "🍩 Increased batch level to #{@level}"
    yield
    @level -= 1
    Rails.logger.info "🍩 Decreased batch level to #{@level}"
    flush if @level == 0
  end

  def broadcast(key, params)
    Rails.logger.info "🍩 Adding #{key} to the broadcast queue."
    @queue << {key: key, params: params}
    flush if @level == 0
  end

  def flush
    # no need to send the same broadcast signal twice.
    @queue.uniq!

    while item = @queue.shift
      Rails.logger.info "🍩 Flushing #{item[:key]} from the broadcast queue."
      ActionCable.server.broadcast(item[:key], item[:params])
    end
  end
end

module Sprinkles::Broadcasted
  extend ActiveSupport::Concern

  # define relationships.
  included do
    after_commit :broadcast_self
  end

  # define class methods.
  module ClassMethods
    def broadcast_collection(id, collection_name)
      Sprinkles::Broadcaster.instance.broadcast("#{name.underscore}_#{id}_#{collection_name}", {})
    end
  end

  # define object methods.
  def broadcast_self
    Sprinkles::Broadcaster.instance.broadcast("#{self.class.name.underscore}_#{id}", {})
    broadcast
  end

  # template method to be implemented in child classes.
  def broadcast
  end
end
