# db/migrate/20240906070604_create_telegram_in_message_reactions.rb
class CreateTelegramInMessageReactions < ActiveRecord::Migration[5.2]
  def up
    create_table :telegram_in_message_reactions, comment: "Таблица для хранения реакций на сообщения" do |t|
      t.string :emoji, null: false, comment: "Смайл реакции"
      t.integer :count, default: 1, null: false, comment: "Количество реакций данного вида"
      t.references :telegram_in_message, null: false, foreign_key: true, comment: "Ссылка на сообщение"

      t.timestamps
    end
  end

  def down
    drop_table :telegram_in_message_reactions
  end
end
