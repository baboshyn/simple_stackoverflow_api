class AnswerCreator
  def initialize(params = {}, question)
    @params = params

    @question = question
  end

  def create
    @question.answers.create!(@params)

    rescue ActiveRecord::RecordInvalid => invalid
    invalid.record
  end
end
