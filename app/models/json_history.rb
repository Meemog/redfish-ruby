class JsonHistory < ApplicationRecord
  self.table_name = "JsonHistory"
  self.primary_key = "id"

  belongs_to :asset,
             foreign_key: "assetId"
end
