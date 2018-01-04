class ConfirmationsController < ApplicationController
  skip_before_action :authenticate, only: [:show]
  before_action :set_user, only: :show

  def show
    render json: @user
  end

  private
  def set_user
    @user = User.find(parsed_id)

    @user.update_attribute(:state, 1)
  end

  def parsed_id
    ConfirmationParser.parse(params[:id])
  end
end
