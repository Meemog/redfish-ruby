class AssetPath < ApplicationRecord
  self.table_name = "AssetPath"
  self.primary_key = "id"

  belongs_to :asset,
             foreign_key: "assetId"
end
