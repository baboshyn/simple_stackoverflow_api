class QuestionPolicy < ApplicationPolicy
  def update?
    user.id == question.user.id
  end

  def destroy?
    user.id == question.user.id
  end

  private
    def question
      record
    end
end
