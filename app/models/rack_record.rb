class RackRecord < ApplicationRecord
  self.table_name = "Rack"
  self.primary_key = "ID"

  has_many :assets,
           foreign_key: "RackId",
           dependent: :destroy
end
