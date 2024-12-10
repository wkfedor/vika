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
    begin
      # Получаем текст из объекта content
      @text_data = get_text_from_content
      @settings['data'].each do |block|
        if block['logic'] == '||'
          result = block['methods'].map { |method| execute_method(method['method'], true) }.reduce(:|)
        else
          result = block['methods'].map { |method| execute_method(method['method'], false) }.first
        end
        puts "Result: #{result}"
        return false unless result  # Возвращаем false, если какой-то метод вернул false
      end
      return true  # Возвращаем true, если все методы отработали успешно
    rescue StandardError => e
      # Логируем ошибку в случае её возникновения
      log_entry(__method__, false, false, e.message)
      raise e # Повторно выбрасываем ошибку, чтобы она могла быть обработана вызывающим кодом
    end
  end

  private

  # Метод для выполнения метода с перехватом исключений
  def execute_method(method_name, is_block)
    begin
      result = send(method_name)
      log_entry(method_name, is_block, result)
      result
    rescue StandardError => e
      # Логируем ошибку в случае её возникновения
      log_entry(method_name, is_block, false, e.message)
      false # Возвращаем false в случае ошибки
    end
  end

  # Метод для создания записи в таблице логов
  def log_entry(method_name, is_block, result, error_message = nil)
    AuditLog.create(
      class_name: self.class.name,
      method_name: method_name,
      content_id: @content.id,
      is_block: is_block,
      result: result,
      error_message: error_message,
      project_id: @content.setting_id
    )
  end

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
    result = false
    result
  end

  # Проверка на наличие в тексте признака женской бытовой техники
  def women_household_appliances
    puts "Method: women_household_appliances, Text: #{@text_data[:text]}"
    false
  end

  # Проверка на наличие в тексте признака товаров для женщин
  def products_for_women
    puts "Method: products_for_women, Text: #{@text_data[:text]}"
    true
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

  def marketplace_self_buy_check_self
    # Первая часть сочетания (приводим к нижнему регистру)
    first_part = ["Цена на WB", "Цена на Wildberries", "Цена на Вб", "Цена ВБ", "Цена на ОЗОН"].map(&:downcase)
    # Вторая часть сочетания (приводим к нижнему регистру)
    second_part = ["ЦЕНА ДЛЯ ВАС", "Ваша цена", "Кэшбек от нас"].map(&:downcase)

    # Приводим текст для проверки к нижнему регистру
    text_to_check = @text_data[:text].downcase

    # Проверяем каждую комбинацию
    first_part.each do |first|
      second_part.each do |second|
        # Проверяем, содержит ли текст сочетание (без границ слова в любой части)
        return true if text_to_check.match?(/#{first}.*#{second}/)
      end
    end

    # Если ни одно сочетание не найдено
    false
  end


end
