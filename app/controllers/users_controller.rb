class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :confirm]

  def create
    UserCreator.new(resource_params)
      .on(:succeeded) { |serialized_resource| render json: serialized_resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def confirm
    if user_from_token(params[:token])

      authorize(:user, :confirm?)

      current_user.confirmed!

      render json: { message: 'user confirmed' }
    else
      render_unauthorized
    end
  end

  private
  def resource_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation).to_h
  end

  def render_unauthorized
    headers['WWW-Authenticate'] = 'Token realm="Application"'

    head 401
  end
end
