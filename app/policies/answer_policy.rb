class AnswerPolicy < ApplicationPolicy
  def update?
    user.id == answer.user_id
  end

  def destroy?
    user.id == answer.user_id
  end

  private
    def answer
      record
    end
end
