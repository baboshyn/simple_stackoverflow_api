class AnswersCreator
  def initialize(params = {})
    @params = params
  end

  def create
    Answer.create!(@params)

    rescue ActiveRecord::RecordInvalid => invalid
    invalid
  end
end
