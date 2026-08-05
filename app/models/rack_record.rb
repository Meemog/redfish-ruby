class RackRecord < ApplicationRecord
  self.table_name = "Rack"
  self.primary_key = "id"

  has_many :assets,
           foreign_key: "rackId",
           dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 255 }

  validates :size,
            numericality: { only_integer: true },
            allow_nil: true

  validates :notes,
            length: { maximum: 255 },
            allow_nil: true
end
