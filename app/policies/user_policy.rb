class UserPolicy < ApplicationPolicy
  def confirm?
    user.unconfirmed?
  end
end
