module Authenticatable
  include ActionController::HttpAuthentication::Token::ControllerMethods
  attr_reader :current_user

  def self.included(base)
    base.before_action :authenticate
  end

  def authenticate
    authenticate_or_request_with_http_token do |token|
      parsed_user(token)
    end
  end

  def parsed_user(token)
    payload, _ = SimpleStackoverflowToken.decode(token)

    @current_user = User.find(payload['user_id']) if payload
  end
end
