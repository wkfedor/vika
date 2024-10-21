# app/services/censor.rb
class Censor
  # Константа для массива сопоставления типов источников с полями, содержащими текст, фото, итд
  SOURCE_MAPPING = {
    "TelegramInMessage" => { text: :html_content }
  }.freeze
  def initialize(settings:, content:)
    @settings = settings
    @content = content
  end

  def run
    # Получаем текст из объекта content
    @text_data = get_text_from_content
    @settings['data'].each do |block|
      if block['logic'] == '||'
        result = block['methods'].map { |method| send(method['method']) }.reduce(:|)
      else
        result = block['methods'].map { |method| send(method['method']) }.first
      end
      puts "Result: #{result}"
    end
  end

  private

  # Метод для получения текста из объекта content
  # Возвращает хэш с текстом в зависимости от типа источника
  def get_text_from_content
    # Получаем тип источника и соответствующий текст
    source_type = @content.processed_content_type
    text_field = SOURCE_MAPPING[source_type][:text]

    # Возвращаем текст из объекта processed_content
    { text: @content.processed_content.send(text_field) }
  end
  # Проверка на наличие в тексте признака женской одежды
  def women_clothing
    puts "Method: women_clothing, Text: #{@text_data[:text]}"
    false
  end

  # Проверка на наличие в тексте признака женской бытовой техники
  def women_household_appliances
    puts "Method: women_household_appliances, Text: #{@text_data[:text]}"
    false
  end

  # Проверка на наличие в тексте признака товаров для женщин
  def products_for_women
    puts "Method: products_for_women, Text: #{@text_data[:text]}"
    false
  end

  # Проверка на наличие рекламы в тексте
  def advertisement
    puts "Method: advertisement, Text: #{@text_data[:text]}"
    true
  end

  # Проверка на наличие информации о продаже от 1 единицы
  def sale_from_one_unit
    puts "Method: sale_from_one_unit, Text: #{@text_data[:text]}"
    true
  end

  # Проверка на отсутствие текста в сообщении
  def without_text
    puts "Method: without_text, Text: #{@text_data[:text]}"
    true
  end
end
