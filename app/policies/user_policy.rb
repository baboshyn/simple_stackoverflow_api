class UserPolicy < ApplicationPolicy
  def confirm?
    user && user.unconfirmed?
  end
end
