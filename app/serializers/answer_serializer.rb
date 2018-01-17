class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id

  has_one :question
end
