class AssetPath < ApplicationRecord
  self.table_name = "AssetPath"
  self.primary_key = "id"

  belongs_to :asset,
             foreign_key: "assetId"

  validates :asset, presence: true

  validates :path, presence: true

  validates :name,
            length: { maximum: 255 },
            allow_nil: true
end
