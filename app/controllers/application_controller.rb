class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  include Authenticatable

  before_action :authenticate

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound do

    head 404
  end
end
