class Permission < ApplicationRecord
  self.table_name = "Permission"
  self.primary_key = "id"

  has_many :role_permissions,
           foreign_key: "permissionId",
           dependent: :destroy

  has_many :roles,
           through: :role_permissions

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 255 }
end
