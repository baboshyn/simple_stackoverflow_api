module Authenticatable
  def authenticate
    unless current_user
      render json: {error: "unauthorized"}, status: 401
    end
  end

  def current_user
    if payload
      @current_user = User.find_by(id: payload['user'])
    end
  end

private
  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token).first
  rescue
    nil
  end
end
