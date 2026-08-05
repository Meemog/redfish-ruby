class RefreshToken < ApplicationRecord
  self.table_name = "RefreshToken"
  self.primary_key = "id"

  belongs_to :user,
              foreign_key: "userId"
end
