class QuestionPolicy < ApplicationPolicy
  def create?
    valid_user?
  end

  def update?
    user_is_author?
  end

  def destroy?
    user_is_author?
  end
end
