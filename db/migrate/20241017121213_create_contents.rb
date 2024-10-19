class CreateContents < ActiveRecord::Migration[5.2]
  def up
    create_table :contents do |t|
      t.string :status, comment: "Статус нового сообщения"
      t.references :setting, foreign_key: true, comment: "Ссылка на проект (Setting)"

      # Полиморфная связь с оригинальным объектом
      t.references :original_source, polymorphic: true, index: true, comment: "Полиморфная связь с оригинальным источником информации (например, сообщение из Telegram, группы ВКонтакте, сайта)"

      # Полиморфная связь с переработанным объектом
      t.references :processed_content, polymorphic: true, index: true, comment: "Полиморфная связь с переработанным содержимым (например, переработанное сообщение)"

      t.timestamps
    end
  end

  def down
    drop_table :contents
  end
end
