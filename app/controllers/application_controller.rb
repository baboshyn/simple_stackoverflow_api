class ApplicationController < ActionController::API
  include Authenticatable

  include Pundit

  rescue_from Pundit::NotAuthorizedError do
    head 403
  end


  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end

  rescue_from ActionController::ParameterMissing do
    head 400
  end
end
