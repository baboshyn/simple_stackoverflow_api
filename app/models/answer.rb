class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true, uniqueness: true
end
