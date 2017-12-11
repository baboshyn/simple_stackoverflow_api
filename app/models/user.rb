class User < ApplicationRecord
  has_secure_password

  validates :login, presence: true

  validates :email, presence: true,
                      length: { maximum: 255 },
                      format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
end
