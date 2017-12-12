class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  include Authenticatable
  # before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end
end
