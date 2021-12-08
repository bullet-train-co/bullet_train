class Webhooks::Outgoing::Delivery < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :endpoint, class_name: "Webhooks::Outgoing::Endpoint"
  belongs_to :event, class_name: "Webhooks::Outgoing::Event"
  has_one :team, through: :endpoint

  ATTEMPT_SCHEDULE = {
    1 => 15.seconds,
    2 => 1.minute,
    3 => 5.minutes,
    4 => 15.minutes,
    5 => 1.hour,
  }

  # 🚅 add belongs_to associations above.

  has_many :delivery_attempts, class_name: "Webhooks::Outgoing::DeliveryAttempt", dependent: :destroy, foreign_key: :delivery_id
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def label_string
    event.short_uuid
  end

  def next_reattempt_delay
    ATTEMPT_SCHEDULE[attempt_count]
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

  def failed?
    !(delivered? || still_attempting?)
  end

  def name
    event.short_uuid
  end

  def max_attempts
    ATTEMPT_SCHEDULE.keys.max
  end

  # 🚅 add methods above.
end
