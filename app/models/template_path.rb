class TemplatePath < ApplicationRecord
  self.table_name = "TemplatePath"
  self.primary_key = "id"

  belongs_to :template,
            foreign_key: "templateId"

  validates :template, presence: true

  validates :path, presence: true

  validates :name,
            length: { maximum: 255 },
            allow_nil: true
end
