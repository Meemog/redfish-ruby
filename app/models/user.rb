class User < ApplicationRecord
  self.table_name = "User"
  self.primary_key = "id"

  belongs_to :role,
           foreign_key: "roleId"
  has_many :refresh_tokens,
           foreign_key: "userId"

  def authenticate(password)
    Hasher.call(password) == self.passwordHash
  end

  def can?(permission_name)
    role.permissions.exists?(name: permission_name)
  end

  def logout
    self.refresh_tokens.destroy_all
  end
end
