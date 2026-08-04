class Asset < ApplicationRecord
  self.table_name = "Asset"
  self.primary_key = "id"

  belongs_to :rack_record,
             foreign_key: "rackId"

  has_many :asset_paths,
           foreign_key: "assetId",
           dependent: :destroy

  has_many :asset_jsons,
           foreign_key: "assetId",
           dependent: :destroy

  def latest_json
    asset_jsons.order(UploadDate: :desc).first
  end
end
