class AssetJson < ApplicationRecord
  self.table_name = "AssetJson"
  self.primary_key = "id"

  belongs_to :asset,
             foreign_key: "assetId"

  validates :asset, presence: true

  validates :rawJson, presence: true

  validates :filename,
            length: { maximum: 255 },
            allow_nil: true
end
