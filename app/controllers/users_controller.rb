class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :confirm]

  def create
    UserCreator.new(resource_params)
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def confirm
    if user(params[:token])
      current_user.update(state: 'confirmed')

      head 200, message: 'user confirmed'
    else
      head 404
    end
  end

  private
  def resource_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation).to_h
  end
end
