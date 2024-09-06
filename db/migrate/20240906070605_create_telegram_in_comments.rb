# db/migrate/20240906070605_create_telegram_in_comments.rb
class CreateTelegramInComments < ActiveRecord::Migration[5.2]
  def up
    create_table :telegram_in_comments, comment: "Таблица для хранения комментариев к сообщениям" do |t|
      t.text :content, null: false, comment: "Текст комментария"
      t.references :telegram_in_message, null: false, foreign_key: true, comment: "Ссылка на сообщение"

      t.timestamps
    end
  end

  def down
    drop_table :telegram_in_comments
  end
end
