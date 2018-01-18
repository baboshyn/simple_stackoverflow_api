class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id
end
