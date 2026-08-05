class RefreshToken < ApplicationRecord
  self.table_name = "RefreshToken"
  self.primary_key = "id"

  belongs_to :user,
              foreign_key: "userId"

  validates :user, presence: true

  validates :tokenHash,
            length: { is: 64 },
            allow_nil: true
end
