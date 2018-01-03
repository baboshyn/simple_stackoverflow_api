class User < ApplicationRecord
  has_secure_password

  enum state: [:unconfirmed, :confirmed]

  validates :login, presence: true

  validates :email, presence: true,
                      uniqueness: { case_sensitive: false },
                      length: { maximum: 255 },
                      format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

  scope :confirmed, -> { where("state > ?", 0) }

  def confirmation_token
    SimpleStackoverflowToken.encode({ user_id: self.id })
  end
end
