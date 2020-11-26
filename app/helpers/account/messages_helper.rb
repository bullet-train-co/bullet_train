module Account::MessagesHelper
  def message_anchor(message)
    return nil unless message
    "message-#{message.id}"
  end
end
