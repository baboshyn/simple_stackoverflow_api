class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :confirm]

  def create
    UserCreator.new(resource_params)
      .on(:succeeded) { |serialized_resource| render json: serialized_resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def confirm
    user_from_token(params[:token])

    authorize(:user, :confirm?)

    current_user.confirmed!

    render json: { message: 'user confirmed' }, satus: 200
  end

  def resource_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation).to_h
  end
end
