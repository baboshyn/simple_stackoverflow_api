class TokensController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    user = User.find_by!(login: resource_params[:login])

    if user.authenticate resource_params[:password]
      token = JsonWebToken.encode({ user_id: user.id })

      render json: { token: token }, status: 201
    else
      render json: { error: { message: 'Invalid password' } }, status: 422
    end
  end

  private
  def resource_params
    params.require(:login).permit(:login, :password)
  end
end
