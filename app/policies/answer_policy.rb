class AnswerPolicy < ApplicationPolicy
  def create?
    valid_user?
  end

  def update?
   valid_user? && user_is_author?
  end

  def destroy?
    valid_user? && user_is_author?
  end
end
