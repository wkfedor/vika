# app/interactors/start_work.rb
class StartWork < ActiveInteraction::Base
  integer :message_id

  def execute
    # 1. Получение настроек проекта
    settings = Setting.first
    puts "Settings: #{settings.inspect}"

    # 2. Инициализация новой сущности Content
    content = Content.new(message_id: message_id)
    puts "Content initialized: #{content.inspect}"

    # 3. Запуск класса Censor с нужными параметрами
    Censor.new(settings).run
  end
end
