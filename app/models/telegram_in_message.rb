class TelegramInMessage < ApplicationRecord
  belongs_to :telegram_in_group
  has_many :telegram_in_media, dependent: :destroy
  has_many :telegram_in_message_reactions, dependent: :destroy
  has_many :telegram_in_comments, dependent: :destroy

  validates :html_content, presence: true
  validates :message_number, presence: true, uniqueness: { scope: :telegram_in_group_id }
end
