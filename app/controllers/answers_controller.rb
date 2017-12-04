class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update, :destroy]

  def create
    answer = AnswersCreator.new(resource_params).create

    if answer.valid?
      render json: answer, status: 201
    else
      render json: answer.errors, status: 422
    end
  end

  def show
    render json: @answer
  end

  def index
    answers = AnswersSearcher.new(params).search

    render json: answers
  end

  def update
    answer = AnswersUpdater.new(@answer, resource_params).update

    if answer.valid?
      render json: answer, status: 200
    else
      render json: answer.errors, status: 422
    end
  end

  def destroy
    AnswersDestroyer.new(@answer).destroy

    head 204
  end

  private
  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def resource_params
    params.require(:answer).permit(:body, :question_id)
  end
end
