class AssetJson < ApplicationRecord
  self.table_name = "AssetJson"
  self.primary_key = "id"

  belongs_to :asset,
             foreign_key: "assetId"
end
