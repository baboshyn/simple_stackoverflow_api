class UsersController < ApplicationController
  def create
    user = UserCreator.new(resource_params).create

    render json: user, status: 201
  end

  private
  def resource_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
