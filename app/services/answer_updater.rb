class AnswerUpdater
  def initialize(answer, params)
    @answer = answer

    @params = params
  end


  def update
    @answer.update!(@params)

    @answer

    rescue ActiveRecord::RecordInvalid => invalid
    invalid.record
  end
end
