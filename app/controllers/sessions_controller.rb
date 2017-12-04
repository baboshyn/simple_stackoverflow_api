class SessionsController < ApplicationController
  def create
    session = SessionsCreator.new(resource_params).create

    if session.is_a?ActiveModel::Errors
      render json: session.messages, status: 422
    else
      render json: session, status: 201
    end
  end

  def destroy
    SessionsDestroyer.new(current_user).destroy

    head 204
  end

  private
  def resource_params
    params.require(:session).permit(:email, :password)
  end
end
