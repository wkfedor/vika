# app/interactors/start_work.rb
class StartWork < ActiveInteraction::Base
  integer :message_id

  def execute
    # 1. Получение настроек проекта
    settings = Setting.first
    puts "Settings: #{settings.inspect}"

    # 2. Инициализация новой сущности Content

    original_message = TelegramInMessage.find(message_id)
    new_message = original_message.duplicate(original: false)
    # 4. Инициализация новой сущности Content
    content = Content.new(
      status: 'new',
      setting: settings,
      original_source: original_message,
      processed_content: new_message
    )
    puts "Content initialized: #{content.inspect}"

    # 5. Сохранение новой сущности Content
    content.save!

    puts "Content initialized: #{content.inspect}"

    # 6. Запуск классов Censor и Mutator с нужными параметрами
    censor_settings = settings.execution_sequence.find { |s| s['class'] == 'Censor' }
    Censor.new(settings: censor_settings, content: content).run
  end
end
