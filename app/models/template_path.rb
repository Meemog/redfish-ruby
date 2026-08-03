class TemplatePath < ApplicationRecord
  self.table_name = "TemplatePath"
  self.primary_key = "id"

  belongs_to :template,
            foreign_key: "templateId"
end
