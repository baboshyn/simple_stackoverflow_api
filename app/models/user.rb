class User < ApplicationRecord
  has_secure_password

  has_many :sessions

  validates :name, presence: true

  validates :email, presence: true,
                      length: { maximum: 255 },
                      format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
end
