class QuestionsUpdater
  def initialize(question, params)
    @question = question

    @params = params
  end

  def update
    @question.update!(@params)

    @question
  end
end
