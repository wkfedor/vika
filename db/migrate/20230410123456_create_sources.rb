class CreateSources < ActiveRecord::Migration[5.2]
  def up
    create_table :sources do |t|
      t.string :name, null: false, comment: "Название источника"
      t.text :description, comment: "Описание источника"
      t.string :url, null: false, comment: "URL источника"
      t.string :source_type, null: false, default: 'сайт', comment: "Тип источника (сайт, группа в телеграмм)"

      t.timestamps
    end

    change_table_comment :sources, "Таблица для хранения источников информации"
  end

  def down
    drop_table :sources
  end
end
