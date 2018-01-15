class AnswersController < ApplicationController
  skip_before_action :authenticate, only: :index

  before_action :set_answer, only: [:update, :destroy]

  before_action :set_question, only: [:create, :index]

  def create
    AnswerCreator.new(resource_params.merge(user: current_user), @question)
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def index
    answers = AnswerSearcher.new(params, @question).search

    render json: answers
  end

  def update
    authorize @answer
    AnswerUpdater.new(@answer, resource_params)
      .on(:succeeded) { |resource| render json: resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def destroy
    authorize @answer
    AnswerDestroyer.new(@answer).destroy

    head 204
  end

  private
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
