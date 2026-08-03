class Path < ApplicationRecord
  self.table_name = "Path"
  self.primary_key = "id"

  belongs_to :asset,
             foreign_key: "assetId"
end
