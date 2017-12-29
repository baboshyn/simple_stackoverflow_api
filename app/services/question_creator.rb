class QuestionCreator
  def initialize(params = {})
    @params = params
  end

  def create
    Question.create!(@params)

    rescue ActiveRecord::RecordInvalid => invalid
    invalid.record
  end
end
