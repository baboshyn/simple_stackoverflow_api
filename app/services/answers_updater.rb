class AnswersUpdater
  def initialize(answer, params)
    @answer = answer

    @params = params
  end

  def update
    @answer.update!(@params)

    @answer
  end
end
