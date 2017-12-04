class Session < ApplicationRecord
  belongs_to :user

  validates :auth_token, uniqueness: true

  before_save :set_token, on: :create

  def set_token
    self.auth_token = SecureRandom.uuid
  end
end
