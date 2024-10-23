class CreateAuditLogs < ActiveRecord::Migration[5.2]
  def up
    create_table :audit_logs do |t|
      t.string :class_name, null: false, comment: "Название класса, в котором был вызван метод"
      t.string :method_name, null: false, comment: "Название метода, который был вызван"
      t.integer :content_id, null: false, comment: "ID элемента контента, с которым был вызван метод"
      t.boolean :is_block, null: false, comment: "Признак, является ли метод частью логического блока"
      t.boolean :result, null: false, comment: "Результат выполнения метода (true или false)"
      t.string :error_message, comment: "Сообщение об ошибке, если метод упал с ошибкой"
      t.integer :project_id, null: false, comment: "ID проекта, к которому относится лог"

      t.timestamps
    end

    # Добавляем индексы для ускорения поиска
    add_index :audit_logs, :content_id, name: "index_audit_logs_on_content_id"
    add_index :audit_logs, :project_id, name: "index_audit_logs_on_project_id"
  end

  def down
    # Удаляем индексы перед удалением таблицы
    remove_index :audit_logs, name: "index_audit_logs_on_content_id"
    remove_index :audit_logs, name: "index_audit_logs_on_project_id"

    drop_table :audit_logs
  end
end
