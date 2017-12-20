class ApplicationController < ActionController::API
  include Authenticatable

  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end

  rescue_from ActionController::ParameterMissing do
    head 422
  end
end
