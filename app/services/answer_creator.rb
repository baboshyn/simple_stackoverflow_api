class AnswerCreator
  def initialize(params = {})
    @params = params

    @question = Question.find(params[:question_id])
  end

  def create
    @question.answers.create!(@params)

    rescue ActiveRecord::RecordInvalid => invalid
    invalid.record
  end
end
