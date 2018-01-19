class TokensController < ApplicationController
  skip_before_action :authenticate, only: [:create]
  before_action :pundit_user, only: :create

  def create
    authorize(:token, :create?)

    if @user.authenticate resource_params[:password]
      token = SimpleStackoverflowToken.encode(user_id: @user.id)

      render json: { token: token }, status: 201
    else
      render json: { password: ['Invalid password'] }, status: 422
    end
  end

  private
  def pundit_user
    @user ||= User.find_by!(email: resource_params[:email].downcase)
  end

  def resource_params
    params.require(:login).permit(:email, :password)
  end
end
