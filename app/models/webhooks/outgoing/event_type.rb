class Webhooks::Outgoing::EventType < ApplicationHash
  self.data = YAML.load_file("config/models/webhooks/outgoing/event_types.yml").map do |topic, events|
    events.map { |event| event == "crud" ? ["created", "updated", "deleted"] : event }.flatten.map { |event| {id: "#{topic}.#{event}"} }
  end.flatten

  def label_string
    name
  end

  def name
    id
  end
end
