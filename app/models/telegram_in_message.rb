class TelegramInMessage < ApplicationRecord
  belongs_to :telegram_in_group
  has_many :telegram_in_media, class_name: 'TelegramInMedia', foreign_key: 'telegram_in_message_id', dependent: :destroy
  #has_many :telegram_in_media, dependent: :destroy # не работает, не понятно по чему, спрочи на форуме
  has_many :telegram_in_message_reactions, dependent: :destroy
  has_many :telegram_in_comments, dependent: :destroy

  validates :html_content, presence: true
  validates :message_number, presence: true, uniqueness: { scope: :telegram_in_group_id }
  validates :views_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end
