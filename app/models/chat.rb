class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :application_id }
  validates :name, presence: true

  before_validation :set_number, on: :create
  after_commit :enqueue_messages_count_update, on: [:create, :destroy]

  private

  def set_number
    max_number = application.chats.maximum(:number) || 0
    self.number = max_number + 1
  end

  # Enqueue job to update the messages_count after commit
  def enqueue_messages_count_update
    UpdateMessagesCountJob.perform_later(self.id)
  end
end
