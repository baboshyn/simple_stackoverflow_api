class TokensController < ApplicationController
  skip_before_action :authenticate, only: [:create]
  before_action :set_user, only: :create

  def create
    if @user.confirmed?
      if @user.authenticate resource_params[:password]
        token = SimpleStackoverflowToken.encode({ user_id: @user.id })

        render json: { token: token }, status: 201
      else
        render json: { password: ['Invalid password'] }, status: 422
      end
    else
      head 403
    end
  end

  private
  def set_user
    @user ||= User.where('email ILIKE?', resource_params[:email]).first

    raise ActiveRecord::RecordNotFound unless @user
  end

  def resource_params
    params.require(:login).permit(:email, :password)
  end
end
