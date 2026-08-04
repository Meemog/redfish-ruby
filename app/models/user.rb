class User < ApplicationRecord
  self.table_name = "User"
  self.primary_key = "id"

  has_one :role,
           foreign_key: "roleId"

  def authenticate(password)
    Hasher.call(password) == self.passwordHash
  end
end
