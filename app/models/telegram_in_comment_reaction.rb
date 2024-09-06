class TelegramInCommentReaction < ApplicationRecord
  belongs_to :telegram_in_comment

  validates :emoji, presence: true
  validates :count, presence: true, numericality: { greater_than_or_equal_to: 1 }
end
