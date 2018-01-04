class TokensController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    user = User.find_by!(email: resource_params[:email])

    if user.authenticate resource_params[:password]
      token = SimpleStackoverflowToken.encode({ user_id: user.id })

      render json: { token: token }, status: 201
    else
      render json: { password: ['Invalid password'] }, status: 422
    end
  end

  private
  def resource_params
    params.require(:login).permit(:email, :password)
  end
end
