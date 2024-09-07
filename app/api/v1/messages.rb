module API
  module V1
    class Messages < Grape::API
      version 'v1', using: :path

      resource :messages do
        desc 'http://localhost:3000/api/v1/messages { "group_id": "1", "group_name": "2", "html_content": "test", "message_number": 136, "media": [ { "file_data": "testdata","file_type": "pdf"} ], "views_count": 10, "views_count_updated_at": "2023-10-01T12:00:00Z", "reactions": [ { "emoji": "😊", "count": 1 }, { "emoji": "👍", "count": 2 }, { "emoji": "😢", "count": 10 } ] }'

        params do
          requires :group_id, type: String, desc: 'Group ID'
          requires :group_name, type: String, desc: 'Group Name'
          requires :html_content, type: String, desc: 'HTML Content'
          requires :message_number, type: Integer, desc: 'Message Number'
          optional :views_count, type: Integer, desc: 'Number of views'  # количество просмотров
          optional :views_updated_at, type: DateTime, desc: 'Date when views count was updated'  # дата обновления количества просмотров
          optional :media, type: Array do
            optional :file_data, type: String, desc: 'File Data'
            optional :file_type, type: String, desc: 'File Type'
          end
          optional :reactions, type: Array do  # реакции на сообщения
            requires :emoji, type: String, desc: 'Emoji'
            requires :count, type: Integer, desc: 'Count of reactions'
          end
        end
        post do
          group = TelegramInGroup.find_or_create_by(group_id: params[:group_id]) do |g|
            g.name = params[:group_name]
          end

          message = group.telegram_in_messages.build(
            html_content: params[:html_content],
            message_number: params[:message_number],
            views_count: params[:views_count] || 0,
            views_updated_at: params[:views_updated_at]
          )

          if message.save
            params[:media]&.each do |media_data|
              message.telegram_in_media.create(
                file_data: media_data[:file_data],
                file_type: media_data[:file_type]
              )
            end

            params[:reactions]&.each do |reaction_data|
              message.telegram_in_message_reactions.create(
                emoji: reaction_data[:emoji],
                count: reaction_data[:count]
              )
            end

            status 200
            { status: 'success' }
          else
            # Вывод расширенной информации об ошибке в консоль
            Rails.logger.error "Failed to save message: #{message.errors.full_messages.join(', ')}"
            Rails.logger.error "Parameters: #{params.inspect}"
            Rails.logger.error "Message attributes: #{message.attributes.inspect}"

            status 409
            { error: 'already exists' }
          end
        end
      end
    end
  end
end
