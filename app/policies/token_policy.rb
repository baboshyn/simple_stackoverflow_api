class TokenPolicy < ApplicationPolicy
  def create?
    user.confirmed?
  end
end
