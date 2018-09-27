module Authenticatable
  include ActionController::HttpAuthentication::Token::ControllerMethods
  attr_reader :current_user

  def self.included(base)
    base.before_action :authenticate
  end

  def authenticate
    authenticate_or_request_with_http_token { |token| user_from_token(token) }
  end

  def user_from_token(token)
    payload, _ = SimpleStackoverflowToken.decode(token)

    @current_user = User.find(payload['user_id']) if payload
  end
end
