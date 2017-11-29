class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :body,  presence: true,  uniqueness: true
end
