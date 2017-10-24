class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|

    render json: exception
  end

  rescue_from ActiveRecord::RecordInvalid, ActiveModel::StrictValidationFailed do |error|

    render json: error, status: 422
  end
end
