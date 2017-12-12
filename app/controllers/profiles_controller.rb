class ProfilesController < ApplicationController
  def show
    render json: current_user, status: 200
  end
end
