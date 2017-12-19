class AnswerCreator
  def initialize(params = {})
    @params = params
  end

  def create
    Answer.create!(@params)

    rescue ActiveRecord::RecordInvalid => invalid
    invalid.record
  end
end
