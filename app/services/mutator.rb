# app/services/mutator.rb
class Mutator
  # Константа для массива сопоставления типов источников с полями, содержащими текст, фото, итд
  SOURCE_MAPPING = {
    "TelegramInMessage" => { text: :html_content }
  }.freeze

  # Константа для списка ключевых слов, которые нужно удалить
  REMOVE_KEYWORDS = ["#АКЦИЯ", "ОТКРОЙ МАГАЗИН ЗДЕСЬ"].freeze

  def initialize(settings:, content:)
    @settings = settings
    @content = content
  end

  def run
    begin
      # Получаем текст из объекта content
      @text_data = get_text_from_content
      @settings['data'].each do |block|
        block['methods'].each do |method|
          execute_method(method['method'])
        end
      end
      # Обновляем текст в объекте content
      update_content_text
      # Сохраняем обновленный объект content в базе данных
      @content.save!
    rescue StandardError => e
      # Логируем ошибку в случае её возникновения
      log_entry(__method__, false, e.message)
      raise e # Повторно выбрасываем ошибку, чтобы она могла быть обработана вызывающим кодом
    end
  end

  private

  # Метод для выполнения метода с перехватом исключений
  def execute_method(method_name)
    begin
      send(method_name)
      log_entry(method_name, true)
    rescue StandardError => e
      # Логируем ошибку в случае её возникновения
      log_entry(method_name, false, e.message)
    end
  end

  # Метод для создания записи в таблице логов
  def log_entry(method_name, result, error_message = nil)
    AuditLog.create(
      class_name: self.class.name,
      method_name: method_name,
      content_id: @content.id,
      is_block: false,  # Устанавливаем is_block в false
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

  # Метод для обновления текста в объекте content
  def update_content_text
    source_type = @content.processed_content_type
    text_field = SOURCE_MAPPING[source_type][:text]
    @content.processed_content.send("#{text_field}=", @text_data[:text])
  end

  # Метод для удаления ключевых слов из текста
  def remove_keywords
    REMOVE_KEYWORDS.each do |keyword|
      @text_data[:text].gsub!(keyword, '')
    end
  end

  # Метод для добавления заглушки "Оригинальная группа"
  def add_original_group_stub
    @text_data[:text] += "\nОригинальная группа <https://ya.ru>ссылка</a>"
  end

  # Метод для добавления заглушки "Контакты для связи"
  def add_contact_info_stub
    @text_data[:text] += "\nКонтакты для связи <https://ya.ru>ссылка</a>"
  end

  # Метод для добавления текста "не забудьте поделиться с друзьями"
  def add_share_reminder
    @text_data[:text] += "\nне забудьте поделиться с друзьями"
  end
end
