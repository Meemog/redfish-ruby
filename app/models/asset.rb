class Asset < ApplicationRecord
  self.table_name = "Asset"
  self.primary_key = "ID"

  belongs_to :rack_record,
             foreign_key: "RackId"

  has_many :paths,
           foreign_key: "AssetId",
           dependent: :destroy

  has_many :json_histories,
           foreign_key: "AssetId",
           dependent: :destroy

  def latest_json
    json_histories.order(UploadDate: :desc).first
  end
end
