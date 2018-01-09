class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :confirm]
  before_action :confirmed_user, only: :confirm

  def create
    UserCreator.new(resource_params)
      .on(:succeeded) { |resource| ConfirmationHandler.publish_confirmation(resource) }
      .on(:succeeded) { head 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def confirm
    @user.update(state: 1)

    render json: @user
  end

  private
  def confirmed_user
    @user = User.find(parsed_id)
  end

  def parsed_id
    ConfirmationParser.parse(params[:id])
  end

  def resource_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation).to_h
  end
end
