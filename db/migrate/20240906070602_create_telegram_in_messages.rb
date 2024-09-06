# db/migrate/20240906070602_create_telegram_in_messages.rb
class CreateTelegramInMessages < ActiveRecord::Migration[5.2]
  def up
    create_table :telegram_in_messages, comment: "Таблица для хранения сообщений" do |t|
      t.text :html_content, null: false, comment: "HTML-текст сообщения"
      t.integer :message_number, null: false, comment: "Номер сообщения"
      t.references :telegram_in_group, null: false, foreign_key: true, comment: "Ссылка на группу"
      t.datetime :created_at, null: false, comment: "Дата создания сообщения"
      t.datetime :updated_at, null: false, comment: "Дата последнего изменения сообщения"
      t.integer :views_count, default: 0, null: false, comment: "Количество просмотров"
      t.datetime :views_updated_at, comment: "Время последнего обновления количества просмотров"

      t.timestamps
    end

    add_index :telegram_in_messages, [:message_number, :telegram_in_group_id], unique: true, name: "index_telegram_in_messages_on_message_number_and_group_id"
  end

  def down
    drop_table :telegram_in_messages
  end
end
