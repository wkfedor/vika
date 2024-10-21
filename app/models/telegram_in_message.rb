class TelegramInMessage < ApplicationRecord
  belongs_to :telegram_in_group
  has_many :telegram_in_media, class_name: 'TelegramInMedia', foreign_key: 'telegram_in_message_id', dependent: :destroy
  #has_many :telegram_in_media, dependent: :destroy # не работает, не понятно по чему, спрочи на форуме
  has_many :telegram_in_message_reactions, dependent: :destroy
  has_many :telegram_in_comments, dependent: :destroy

  validates :html_content, presence: true
  validates :message_number, presence: true, uniqueness: { scope: [:telegram_in_group_id, :original] }
  validates :views_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def duplicate(original: false)
    new_message = self.dup
    new_message.original = original
    new_message.save!

    self.telegram_in_media.each do |media|
      new_message.telegram_in_media.create!(media.attributes.except('id', 'telegram_in_message_id'))
    end

    self.telegram_in_message_reactions.each do |reaction|
      new_message.telegram_in_message_reactions.create!(reaction.attributes.except('id', 'telegram_in_message_id'))
    end

    self.telegram_in_comments.each do |comment|
      new_message.telegram_in_comments.create!(comment.attributes.except('id', 'telegram_in_message_id'))
    end

    new_message
  end
end
