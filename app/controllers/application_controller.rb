class ApplicationController < ActionController::API
  include Authenticatable

  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound do

    head 404
  end
end
