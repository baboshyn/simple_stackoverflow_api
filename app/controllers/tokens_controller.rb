class TokensController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    token = Token.new(resource_params).save

    if token.is_a?ActiveModel::Errors
      render json: token.messages, status: 422
    else
      render json: { token: token }, status: 201
    end
  end

  private
  def resource_params
    params.require(:token).permit(:email, :password)
  end
end
