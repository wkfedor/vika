class TelegramInMedia < ApplicationRecord
  belongs_to :telegram_in_message

  validates :file_data, presence: true
  validates :file_type, presence: true
end
