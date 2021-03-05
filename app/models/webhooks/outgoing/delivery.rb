class Webhooks::Outgoing::Delivery < ApplicationRecord
  has_many :delivery_attempts, dependent: :destroy
  belongs_to :endpoint
  belongs_to :event
  @@reattempt_schedule = {
    1 => 15.seconds,
    2 => 1.minute,
    3 => 5.minutes,
    4 => 15.minutes,
    5 => 1.hour,
  }
  def next_reattempt_delay
    @@reattempt_schedule[attempt_count]
  end

  def deliver_async
    if still_attempting?
      Webhooks::Outgoing::DeliveryJob.set(wait: next_reattempt_delay).perform_later(self)
    end
  end

  def deliver
    if delivery_attempts.create.attempt
      touch(:delivered_at)
    else
      deliver_async
    end
  end

  def attempt_count
    delivery_attempts.count
  end

  def delivered?
    delivered_at.present?
  end

  def still_attempting?
    return false if delivered?
    attempt_count < max_attempts
  end

  def name
    event.short_uuid
  end

  def max_attempts
    @@reattempt_schedule.keys.max
  end
end
