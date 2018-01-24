class AnswersController < ApplicationController
  skip_before_action :authenticate, only: :index

  before_action :set_answer, only: [:update, :destroy]

  before_action :set_question, only: [:create, :index]

  before_action :authorization, only: [:update, :destroy]

  def index
    answers = AnswerSearcher.new(params, @question).search

    render json: answers
  end

  def create
    authorize(:answer, :create?)

    AnswerCreator.new(resource_params.merge(user: current_user), @question)
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    AnswerUpdater.new(@answer, resource_params.except(:question_id))
      .on(:succeeded) { |resource| render json: resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def destroy
    AnswerDestroyer.new(@answer).destroy

    head 204
  end

  private
  def authorization
    authorize @answer
  end

  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id] || resource_params[:question_id])
  end

  def resource_params
    params.require(:answer).permit(:body, :question_id).to_h
  end
end
