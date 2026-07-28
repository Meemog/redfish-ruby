class JsonHistory < ApplicationRecord
  self.table_name = "JsonHistory"
  self.primary_key = "ID"

  belongs_to :asset,
             foreign_key: "AssetId"
end
