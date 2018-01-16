class QuestionPolicy < ApplicationPolicy
  def update?
    user.id == question.user_id
  end

  def destroy?
    user.id == question.user_id
  end

  private
    def question
      record
    end
end
