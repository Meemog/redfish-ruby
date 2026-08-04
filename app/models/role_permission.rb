class RolePermission < ApplicationRecord
  self.table_name = "RolePermission"
  self.primary_key = nil

  belongs_to :role,
             foreign_key: "roleId"

  belongs_to :permission,
             foreign_key: "permissionId"
end
