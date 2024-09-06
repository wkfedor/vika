class TelegramInComment < ApplicationRecord
  belongs_to :telegram_in_message
  has_many :telegram_in_comment_reactions, dependent: :destroy

  validates :content, presence: true
end
