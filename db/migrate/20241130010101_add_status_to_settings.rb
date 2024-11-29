
class AddStatusToSettings < ActiveRecord::Migration[5.2]
  def up
    add_column :settings, :status, :string, null: false, default: "work", comment: "Статус проекта, работает, выключен, на модерации"
  end

  def down
    remove_column :settings, :status
  end
end
