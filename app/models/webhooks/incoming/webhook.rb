module Webhooks::Incoming::Webhook
  def verify_authenticity
    raise "you must either implement `verify_authenticity` in #{self.class.name} or perform verification and set `verified_at` in #{self.class.name}sController."
  end

  def verified?
    unless verified_at
      touch(:verified_at) if verify_authenticity
    end
    verified_at.present?
  end

  def process_async
    Webhooks::Incoming::WebhookProcessingJob.perform_later(self)
  end

  def processed?
    processed_at.present?
  end

  def mark_processed
    touch(:processed_at)
  end

  def verify_and_process
    return if processed?
    if verified?
      process
      mark_processed
    end
  end
end
