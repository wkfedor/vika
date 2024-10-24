class AddTestSettingsData < ActiveRecord::Migration[7.0]
  def up
    Setting.create(
      project_name: 'Леди в тренде',
      project_description: 'Постим сообщение из телеграмм групп с распродажами, опт от 1 еденицы, женская одежда',
      execution_sequence: [
        {
          class: 'Censor',
          data: [
            {
              logic: '||',
              methods: [
                { method: 'women_clothing', comment: 'Проверка на наличие в тексте признака женской одежды' },
                { method: 'women_household_appliances', comment: 'Женская бытовая техника' },
                { method: 'products_for_women', comment: 'Товары для женщин' }
              ]
            },
            {
              methods: [
                { method: 'advertisement', comment: 'Проверка на наличие рекламы' }
              ]
            },
            {
              methods: [
                { method: 'sale_from_one_unit', comment: 'Продажа от 1 еденицы' }
              ]
            },
            {
              methods: [
                { method: 'without_text', comment: 'Проверка на отсутствие текста' }
              ]
            }
          ]
        },
        {
          class: 'Mutator',
          data: [
            {
              methods: [
                { method: 'add_original_group_stub', comment: 'Оригинальная группа' }
              ]
            },
            {
              methods: [
                { method: 'add_contact_info_stub', comment: 'Контакты для связи' }
              ]
            },
            {
              methods: [
                { method: 'add_share_reminder', comment: 'не забудьте поделиться с друзьями' }
              ]
            }
          ]
        }
      ]
    )
  end

  def down
    Setting.find_by(project_name: 'Леди в тренде')&.destroy
  end
end
