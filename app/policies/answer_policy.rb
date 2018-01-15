class AnswerPolicy < ApplicationPolicy
  def update?
    return true if user.id == answer.user.id
  end

  def destroy?
    return true if user.id == answer.user.id
  end

  private
    def answer
      record
    end
end
