module Authenticatable
  attr_reader :current_user

  def authenticate
    if payload
      @current_user = User.find(payload['user'])
    else
      render json: {error: "unauthorized"}, status: 401
    end
  end

private
  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token).first
  rescue NoMethodError
    nil
  end
end


