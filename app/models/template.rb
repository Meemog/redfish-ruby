class Template < ApplicationRecord
  self.table_name = "Template"
  self.primary_key = "id"

  has_many :template_paths,
            foreign_key: "templateId",
            dependent: :destroy
end
