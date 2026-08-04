class Permission < ApplicationRecord
  self.table_name = "Permission"
  self.primary_key = "id"

  has_many :role_permissions,
           foreign_key: "permissionId",
           dependent: :destroy

  has_many :roles,
           through: :role_permissions
end
