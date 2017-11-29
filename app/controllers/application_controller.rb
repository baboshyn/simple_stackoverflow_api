class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|

    render json: exception
  end
end
