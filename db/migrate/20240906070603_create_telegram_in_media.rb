# db/migrate/20240906070603_create_telegram_in_media.rb
class CreateTelegramInMedia < ActiveRecord::Migration[5.2]
  def up
    create_table :telegram_in_media, comment: "Таблица для хранения медиафайлов" do |t|
      t.text :file_data, null: false, comment: "Данные файла в формате Base64"
      t.string :file_type, null: false, comment: "Тип файла (например, image/jpeg, video/mp4)"
      t.references :telegram_in_message, null: false, foreign_key: true, comment: "Ссылка на сообщение"

      t.timestamps
    end
  end

  def down
    drop_table :telegram_in_media
  end
end
