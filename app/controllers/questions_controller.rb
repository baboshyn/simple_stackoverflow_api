class QuestionsController < ApplicationController
  skip_before_action :authenticate, only: [:show, :index]

  before_action :set_question, only: [:show, :update, :destroy]

  def create
    question = QuestionsCreator.new(resource_params).create

    if question.valid?
      render json: question, status: 201
    else
      render json: question.errors, status: 422
    end
  end

  def show
    render json: @question
  end

  def index
    questions = QuestionsSearcher.new(params).search

    render json: questions
  end

  def update
    question = QuestionsUpdater.new(@question, resource_params).update

    if question.valid?
      render json: question
    else
      render json: question.errors, status: 422
    end
  end

  def destroy
    QuestionsDestroyer.new(@question).destroy

    head 204
  end

  private
  def set_question
    @question ||= Question.find(params[:id])
  end

  def resource_params
    params.require(:question).permit(:title, :body)
  end
end
