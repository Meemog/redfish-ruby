class Asset < ApplicationRecord
  self.table_name = "Asset"
  self.primary_key = "id"

  belongs_to :rack_record,
             foreign_key: "rackId"

  has_many :paths,
           foreign_key: "assetId",
           dependent: :destroy

  has_many :json_histories,
           foreign_key: "assetId",
           dependent: :destroy

  def latest_json
    json_histories.order(UploadDate: :desc).first
  end
end
