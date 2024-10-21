# app/models/content.rb
class Content < ApplicationRecord
  belongs_to :setting
  belongs_to :original_source, polymorphic: true
  belongs_to :processed_content, polymorphic: true
end
