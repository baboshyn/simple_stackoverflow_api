class AnswersController < ApplicationController
  skip_before_action :authenticate, only: :index

  before_action :set_answer, only: [:update, :destroy]

  def create
    answer = AnswerCreator.new(resource_params).create

    if answer.valid?
      render json: answer, status: 201
    else
      render json: answer.errors, status: 422
    end
  end

  def index
    answers = AnswerSearcher.new(params).search

    render json: answers
  end

  def update
    answer = AnswerUpdater.new(@answer, resource_params).update

    if answer.valid?
      render json: answer
    else
      render json: answer.errors, status: 422
    end
  end

  def destroy
    AnswerDestroyer.new(@answer).destroy

    head 204
  end

  private
  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def resource_params
    params.require(:answer).permit(:body, :question_id).to_h
  end
end
