class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    UserCreator.new(resource_params).call
    .on(:succeeded) { |resource| render json: resource, status: 201 }
    .on(:failed) { |errors| render json: errors, status: 422 }
    .call
  end

  private
  def resource_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation).to_h
  end
end
