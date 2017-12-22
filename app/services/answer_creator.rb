class AnswerCreator
  def initialize(params = {}, parent)
    @params = params

    @question = parent
  end

  def create
    @question.answers.create!(@params)

    rescue ActiveRecord::RecordInvalid => invalid
    invalid.record
  end
end
