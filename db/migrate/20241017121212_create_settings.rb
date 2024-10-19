class CreateSettings < ActiveRecord::Migration[5.2]
  def up
    create_table :settings do |t|
      t.string :project_name, null: false, comment: "Название проекта"
      t.text :project_description, comment: "Описание проекта"
      t.jsonb :execution_sequence, null: false, default: [], comment: "Последовательность выполнения классов и методов"

      t.timestamps
    end
  end

  def down
    drop_table :settings
  end
end
