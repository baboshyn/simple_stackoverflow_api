class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    user = UsersCreator.new(resource_params).create

    if user.valid?
      render json: user, status: 201
    else
      render json: user.errors, status: 422
    end
  end

  private
  def resource_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation).to_h
  end
end
