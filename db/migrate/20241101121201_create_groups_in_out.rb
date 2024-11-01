class CreateGroupsInOut < ActiveRecord::Migration[5.2]
  def up
    create_table :groups_in_out, comment: "Таблица для хранения групп (входящих и исходящих)" do |t|
      t.references :groupable, polymorphic: true, null: false, comment: "Ссылка на конкретную группу (полиморфная связь)"
      t.string :direction, null: false, comment: "Направление группы (incoming, outgoing)"
      t.references :project, null: false, foreign_key: true, comment: "Ссылка на проект"
      t.timestamps
    end
  end

  def down
    drop_table :groups_in_out
  end
end

# # Модель для groups_in_out
# class GroupsInOut < ApplicationRecord
#   belongs_to :groupable, polymorphic: true
#   belongs_to :project
# end
#
# # Модель для telegram_in_groups
# class TelegramInGroup < ApplicationRecord
#   has_many :groups_in_out, as: :groupable
# end
#
# # Модель для vk_groups
# class VkGroup < ApplicationRecord
#   has_many :groups_in_out, as: :groupable
# end
#
# # Модель для vaiber_group
# class VaiberGroup < ApplicationRecord
#   has_many :groups_in_out, as: :groupable
# end
#
# # Модель для projects
# class Project < ApplicationRecord
#   has_many :groups_in_out
# end
