class UpdateMessagesCountJob < ApplicationJob
  queue_as :default

  def perform(chat_id)
    chat = Chat.find(chat_id)
    messages_count = chat.messages.count
    chat.update!(messages_count: messages_count)
  end
end
