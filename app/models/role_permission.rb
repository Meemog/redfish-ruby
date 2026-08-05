class RolePermission < ApplicationRecord
  self.table_name = "RolePermission"
  self.primary_key = nil

  belongs_to :role,
             foreign_key: "roleId"

  belongs_to :permission,
             foreign_key: "permissionId"

  validates :role, presence: true
  validates :permission, presence: true

  validates :permissionId,
            uniqueness: { scope: :roleId }
end
