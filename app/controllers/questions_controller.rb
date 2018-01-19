class QuestionsController < ApplicationController
  skip_before_action :authenticate, only: [:show, :index]

  before_action :set_question, only: [:show, :update, :destroy]

  def show
    render json: @question
  end

  def index
    questions = QuestionSearcher.new(params).search

    render json: questions
  end

  def create
    authorize(:question, :create?)
    QuestionCreator.new(resource_params.merge(user: current_user))
      .on(:succeeded) { |resource| render json: resource, status: 201 }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def update
    authorize @question
    QuestionUpdater.new(@question, resource_params)
      .on(:succeeded) { |resource| render json: resource }
      .on(:failed) { |errors| render json: errors, status: 422 }
      .call
  end

  def destroy
    authorize @question
    QuestionDestroyer.new(@question).destroy

    head 204
  end

  private
  def set_question
    @question ||= Question.find(params[:id])
  end

  def resource_params
    params.require(:question).permit(:title, :body).to_h
  end
end
