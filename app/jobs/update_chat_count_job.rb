class UpdateChatsCountJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = Application.find(application_id)
    chats_count = application.chats.count
    application.update!(chats_count: chats_count)
  end
end
