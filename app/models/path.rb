class Path < ApplicationRecord
  self.table_name = "Path"
  self.primary_key = "ID"

  belongs_to :asset,
             foreign_key: "AssetId"
end
