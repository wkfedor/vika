# app/api/base.rb
require_relative 'v1/messages'

module API
  class Base < Grape::API
    format :json
    prefix :api

    mount API::V1::Messages

    add_swagger_documentation(
      api_version: 'v1',
      hide_documentation_path: true,
      mount_path: '/swagger_doc',
      hide_format: true
    )
  end
end
