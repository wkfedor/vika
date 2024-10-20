class AddTestSettingsData < SeedMigration::Migration
  def up
    Setting.create(
      project_name: 'Леди в тренде',
      project_description: 'Постим сообщение из телеграмм групп с распродажами, опт от 1 еденицы, женская одежда',
      execution_sequence: [
        {
          logic: '||',
          data: [
            { class: 'Censor', method: 'women_clothing', comment: 'Проверка на наличие в тексте признака женской одежды' },
            { class: 'Censor', method: 'women_household_appliances', comment: 'Женская бытовая техника' },
            { class: 'Censor', method: 'products_for_women', comment: 'Товары для женщин' }
          ]
        },
        {
          logic: nil,
          data: [
            { class: 'Censor', method: 'advertisement', comment: 'Проверка на наличие рекламы' }
          ]
        },
        {
          logic: nil,
          data: [
            { class: 'Censor', method: 'sale_from_one_unit', comment: 'Продажа от 1 еденицы' }
          ]
        },
        {
          logic: nil,
          data: [
            { class: 'Censor', method: 'without_text', comment: 'Проверка на отсутствие текста' }
          ]
        }
      ]
    )
  end

  def down
    Setting.find_by(project_name: 'Леди в тренде')&.destroy
  end
end