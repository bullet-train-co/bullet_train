class Webhooks::Outgoing::DeliveryAttempt < ApplicationRecord
  belongs_to :delivery
  scope :successful, -> { where(response_code: 200) }

  before_create do
    self.attempt_number = delivery.attempt_count + 1
  end

  def still_attempting?
    error_message.nil? && response_code.nil?
  end

  def successful?
    response_code == 200
  end

  def attempt
    uri = URI.parse(delivery.endpoint_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    request = Net::HTTP::Post.new(uri.path)
    request.add_field("Content-Type", "application/json")
    request.body = delivery.event.payload.to_json

    begin
      response = http.request(request)
      self.response_message = response.message
      self.response_code = response.code
      self.response_body = response.body
    rescue Exception => exception
      self.error_message = exception.message
    end

    save
    response_code == 200
  end

  def name
    "#{attempt_number.ordinalize} Attempt"
  end
end
