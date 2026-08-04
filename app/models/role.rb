class Role < ApplicationRecord
  self.table_name = "Role"
  self.primary_key = "id"

  has_many :users,
            foreign_key: "roleId",
            dependent: :destroy
end
