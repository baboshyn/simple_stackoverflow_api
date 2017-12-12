module Authenticatable
  attr_reader :current_user

  def authenticate
    authenticate_or_request_with_http_token do |token|

      payload = JsonWebToken.decode(token)

      @current_user = User.find(payload[0]['user']) if payload
    end
  end
end
