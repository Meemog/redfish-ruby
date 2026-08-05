class Role < ApplicationRecord
  self.table_name = "Role"
  self.primary_key = "id"

  has_many :users,
           foreign_key: "roleId",
           dependent: :restrict_with_error

  has_many :role_permissions,
           foreign_key: "roleId",
           dependent: :destroy

  has_many :permissions,
           through: :role_permissions

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 255 }
end
