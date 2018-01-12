class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :confirm]

  def create
    UserCreator.new(resource_params)
      .on(:succeeded) { |resource| ConfirmationHandler.publish_confirmation(resource) }
      .on(:succeeded) { head 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def confirm
    user(params[:token]).update(state: 1)

    head 200, message: 'confirmed'
  end

  private
  def resource_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation).to_h
  end
end
