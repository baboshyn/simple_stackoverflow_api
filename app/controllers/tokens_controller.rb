class TokensController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  def create
    authorize(:token, :create?)

    token = SimpleStackoverflowToken.encode(user_id: @current_user.id)

    render json: { token: token }, status: 201
  end

  private
  def authenticate
    authenticate_or_request_with_http_basic do |email, password|

      @current_user = User.find_by!(email: email.downcase)&.authenticate password
    end
  end
end
