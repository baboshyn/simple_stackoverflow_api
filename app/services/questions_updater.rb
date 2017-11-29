class QuestionsUpdater
  def initialize(question, params)
    @question = question

    @params = params
  end

  def update
    @question.update!(@params)

    @question

    rescue ActiveRecord::RecordInvalid => invalid
    invalid.record
  end
end
