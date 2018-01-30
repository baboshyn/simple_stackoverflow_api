class AnswersController < ApplicationController
  skip_before_action :authenticate, only: :index

  before_action :set_answer, only: [:update, :destroy]

  before_action :set_question, only: [:create, :index]

  before_action :authorize_answer, only: [:update, :destroy]

  def index
    answers = AnswerSearcher.new(params, @question).search

    render json: answers
  end

  def create
    authorize(:answer, :create?)

    AnswerCreator.new(create_params.merge(user: current_user), @question)
      .on(:succeeded) { |serialized_resource| render json: serialized_resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    AnswerUpdater.new(@answer, update_params)
      .on(:succeeded) { |serialized_resource| render json: serialized_resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def destroy
    AnswerDestroyer.new(@answer).destroy

    head 204
  end

  private
  def authorize_answer
    authorize @answer
  end

  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id] || create_params[:question_id])
  end

  def create_params
    params.require(:answer).permit(:body, :question_id).to_h
  end

  def update_params
    params.require(:answer).permit(:body).to_h
  end
end
