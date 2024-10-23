# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_10_23_121212) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audit_logs", force: :cascade do |t|
    t.string "class_name", null: false, comment: "Название класса, в котором был вызван метод"
    t.string "method_name", null: false, comment: "Название метода, который был вызван"
    t.integer "content_id", null: false, comment: "ID элемента контента, с которым был вызван метод"
    t.boolean "is_block", null: false, comment: "Признак, является ли метод частью логического блока"
    t.boolean "result", null: false, comment: "Результат выполнения метода (true или false)"
    t.string "error_message", comment: "Сообщение об ошибке, если метод упал с ошибкой"
    t.integer "project_id", null: false, comment: "ID проекта, к которому относится лог"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["content_id"], name: "index_audit_logs_on_content_id"
    t.index ["project_id"], name: "index_audit_logs_on_project_id"
  end

  create_table "censors", comment: "Таблица для хранения правил цензуры", force: :cascade do |t|
    t.string "name", null: false, comment: "Название правила"
    t.text "description", comment: "Описание правила"
    t.text "check_data", comment: "Массив данных для проверки"
    t.string "check_rule", null: false, comment: "Правило проверки (точное совпадение, частичное совпадение)"
    t.string "action", null: false, comment: "Действие проверки (отклонить, предупредить)"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "contents", force: :cascade do |t|
    t.string "status", comment: "Статус нового сообщения"
    t.bigint "setting_id", comment: "Ссылка на проект (Setting)"
    t.string "original_source_type"
    t.bigint "original_source_id", comment: "Полиморфная связь с оригинальным источником информации (например, сообщение из Telegram, группы ВКонтакте, сайта)"
    t.string "processed_content_type"
    t.bigint "processed_content_id", comment: "Полиморфная связь с переработанным содержимым (например, переработанное сообщение)"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["original_source_type", "original_source_id"], name: "idx_original_source"
    t.index ["processed_content_type", "processed_content_id"], name: "idx_processed_content"
    t.index ["setting_id"], name: "index_contents_on_setting_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "settings", force: :cascade do |t|
    t.string "project_name", null: false, comment: "Название проекта"
    t.text "project_description", comment: "Описание проекта"
    t.jsonb "execution_sequence", default: [], null: false, comment: "Последовательность выполнения классов и методов"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "sources", comment: "Таблица для хранения источников информации", force: :cascade do |t|
    t.string "name", null: false, comment: "Название источника"
    t.text "description", comment: "Описание источника"
    t.string "url", null: false, comment: "URL источника"
    t.string "source_type", default: "сайт", null: false, comment: "Тип источника (сайт, группа в телеграмм)"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "telegram_in_comment_reactions", comment: "Таблица для хранения реакций на комментарии", force: :cascade do |t|
    t.string "emoji", null: false, comment: "Смайл реакции"
    t.integer "count", default: 1, null: false, comment: "Количество реакций данного вида"
    t.bigint "telegram_in_comment_id", null: false, comment: "Ссылка на комментарий"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["telegram_in_comment_id"], name: "index_telegram_in_comment_reactions_on_telegram_in_comment_id"
  end

  create_table "telegram_in_comments", comment: "Таблица для хранения комментариев к сообщениям", force: :cascade do |t|
    t.text "content", null: false, comment: "Текст комментария"
    t.bigint "telegram_in_message_id", null: false, comment: "Ссылка на сообщение"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["telegram_in_message_id"], name: "index_telegram_in_comments_on_telegram_in_message_id"
  end

  create_table "telegram_in_groups", comment: "Таблица для хранения групп", force: :cascade do |t|
    t.string "name", null: false, comment: "Название группы"
    t.string "group_id", null: false, comment: "Уникальный идентификатор группы"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["group_id"], name: "index_telegram_in_groups_on_group_id", unique: true
  end

  create_table "telegram_in_media", comment: "Таблица для хранения медиафайлов", force: :cascade do |t|
    t.text "file_data", null: false, comment: "Данные файла в формате Base64"
    t.string "file_type", null: false, comment: "Тип файла (например, image/jpeg, video/mp4)"
    t.bigint "telegram_in_message_id", null: false, comment: "Ссылка на сообщение"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["telegram_in_message_id"], name: "index_telegram_in_media_on_telegram_in_message_id"
  end

  create_table "telegram_in_message_reactions", comment: "Таблица для хранения реакций на сообщения", force: :cascade do |t|
    t.string "emoji", null: false, comment: "Смайл реакции"
    t.integer "count", default: 1, null: false, comment: "Количество реакций данного вида"
    t.bigint "telegram_in_message_id", null: false, comment: "Ссылка на сообщение"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["telegram_in_message_id"], name: "index_telegram_in_message_reactions_on_telegram_in_message_id"
  end

  create_table "telegram_in_messages", comment: "Таблица для хранения сообщений", force: :cascade do |t|
    t.text "html_content", null: false, comment: "HTML-текст сообщения"
    t.integer "message_number", null: false, comment: "Номер сообщения"
    t.bigint "telegram_in_group_id", null: false, comment: "Ссылка на группу"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "views_count", default: 0, null: false, comment: "Количество просмотров"
    t.datetime "views_updated_at", precision: nil, comment: "Время последнего обновления количества просмотров"
    t.boolean "original", default: true, null: false, comment: "Оригинальное сообщение или сообщение для переделки"
    t.index ["telegram_in_group_id", "message_number", "original"], name: "index_messages_on_group_id_number_original", unique: true
    t.index ["telegram_in_group_id"], name: "index_telegram_in_messages_on_telegram_in_group_id"
  end

  add_foreign_key "contents", "settings"
  add_foreign_key "telegram_in_comment_reactions", "telegram_in_comments"
  add_foreign_key "telegram_in_comments", "telegram_in_messages"
  add_foreign_key "telegram_in_media", "telegram_in_messages"
  add_foreign_key "telegram_in_message_reactions", "telegram_in_messages"
  add_foreign_key "telegram_in_messages", "telegram_in_groups"
end
