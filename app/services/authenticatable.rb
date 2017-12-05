module Authenticatable
  def authenticate
    authenticate_or_request_with_http_token do |token|
      @current_user = User.joins(:sessions)
                          .find_by(sessions: { auth_token: token })

    end
  end
end
