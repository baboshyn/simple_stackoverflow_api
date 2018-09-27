class TokenPolicy < ApplicationPolicy
  def create?
    valid_user?
  end
end
