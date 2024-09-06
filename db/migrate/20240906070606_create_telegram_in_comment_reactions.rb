# db/migrate/20240906070606_create_telegram_in_comment_reactions.rb
class CreateTelegramInCommentReactions < ActiveRecord::Migration[5.2]
  def up
    create_table :telegram_in_comment_reactions, comment: "Таблица для хранения реакций на комментарии" do |t|
      t.string :emoji, null: false, comment: "Смайл реакции"
      t.integer :count, default: 1, null: false, comment: "Количество реакций данного вида"
      t.references :telegram_in_comment, null: false, foreign_key: true, comment: "Ссылка на комментарий"

      t.timestamps
    end
  end

  def down
    drop_table :telegram_in_comment_reactions
  end
end
