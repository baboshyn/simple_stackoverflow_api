class TokensController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    user = User.find_by(login: resource_params[:login])

    if user and user.authenticate resource_params[:password]
      token = JsonWebToken.encode({ user: user.id })

      render json: { token: token }, status: 201
    else
      render json: { error: 'Invalid login or password' }, status: 404
    end
  end

  private
  def resource_params
    params.require(:token).permit(:login, :password)
  end
end
