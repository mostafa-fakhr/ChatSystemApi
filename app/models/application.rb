class Application < ApplicationRecord
  has_many :chats, dependent: :destroy

  # Ensure the token is present and unique
  validates :token, presence: true, uniqueness: true
  validates :name, presence: true

  before_validation :generate_token, on: :create
  after_commit :enqueue_chats_count_update, on: [:create, :destroy]

  # Prevent updating the token once the application is created
  def token=(value)
    if persisted?
      raise ActiveRecord::ReadOnlyRecord, "Token cannot be changed"
    else
      super
    end
  end

  private

  # Generate a unique token
  def generate_token
    return if token.present?

    begin
      self.token = SecureRandom.hex(10)
    end while self.class.exists?(token: token) 
  end

  # Enqueue job to update the chats_count after commit
  def enqueue_chats_count_update
    UpdateChatsCountJob.perform_later(self.id)
  end
end
