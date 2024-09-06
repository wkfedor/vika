class CreateCensors < ActiveRecord::Migration[5.2]
  def up
    create_table :censors do |t|
      t.string :name, null: false, comment: "Название правила"
      t.text :description, comment: "Описание правила"
      t.text :check_data, comment: "Массив данных для проверки"
      t.string :check_rule, null: false, comment: "Правило проверки (точное совпадение, частичное совпадение)"
      t.string :action, null: false, comment: "Действие проверки (отклонить, предупредить)"

      t.timestamps
    end

    change_table_comment :censors, "Таблица для хранения правил цензуры"
  end

  def down
    drop_table :censors
  end
end
