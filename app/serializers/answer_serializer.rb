class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body

  has_one :question
end
