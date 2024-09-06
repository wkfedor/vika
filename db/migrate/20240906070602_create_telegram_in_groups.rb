# db/migrate/20240906070602_create_telegram_in_groups.rb
class CreateTelegramInGroups < ActiveRecord::Migration[5.2]
  def up
    create_table :telegram_in_groups, comment: "Таблица для хранения групп" do |t|
      t.string :name, null: false, comment: "Название группы"
      t.string :group_id, null: false, comment: "Уникальный идентификатор группы"

      t.timestamps
    end

    add_index :telegram_in_groups, :group_id, unique: true, name: "index_telegram_in_groups_on_group_id"
  end

  def down
    drop_table :telegram_in_groups
  end
end
