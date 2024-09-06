module API
  module V1
    class Messages < Grape::API
      version 'v1', using: :path

      resource :messages do
        desc 'Create a new message'
        params do
          requires :group_id, type: String, desc: 'Group ID'
          requires :group_name, type: String, desc: 'Group Name'
          requires :html_content, type: String, desc: 'HTML Content'
          requires :message_number, type: Integer, desc: 'Message Number'
           optional :media, type: Array do
             requires :file_data, type: String, desc: 'File Data'
             requires :file_type, type: String, desc: 'File Type'
           end
        end
        post do
          group = TelegramInGroup.find_or_create_by(group_id: params[:group_id]) do |g|
            g.name = params[:group_name]
          end

          message = group.telegram_in_messages.build(
            html_content: params[:html_content],
            message_number: params[:message_number]
          )

          if message.save
            params[:media]&.each do |media_data|
              message.telegram_in_media.create(
                file_data: media_data[:file_data],
                file_type: media_data[:file_type]
              )
            end
            status 200
            { status: 'success' }
          else
            status 409
            { error: 'already exists' }
          end
        end
      end
    end
  end
end
