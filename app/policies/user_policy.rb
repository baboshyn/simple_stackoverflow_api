class UserPolicy < ApplicationPolicy
  def confirm?
    user.state == 'unconfirmed'
  end
end
