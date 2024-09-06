class TelegramInGroup < ApplicationRecord
  has_many :telegram_in_messages, dependent: :destroy

  validates :name, presence: true
  validates :group_id, presence: true, uniqueness: true
end
