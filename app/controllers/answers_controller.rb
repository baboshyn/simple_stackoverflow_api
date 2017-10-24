class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update, :destroy]

  def create
    answer = AnswersCreator.new(resource_params).create

    render json: answer, status: 201
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

    render json: answer
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
