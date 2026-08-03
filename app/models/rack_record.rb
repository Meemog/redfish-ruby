class RackRecord < ApplicationRecord
  self.table_name = "Rack"
  self.primary_key = "id"

  has_many :assets,
           foreign_key: "rackId",
           dependent: :destroy
end
