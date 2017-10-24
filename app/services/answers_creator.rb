class AnswersCreator
  def initialize(params = {})
    @params = params
  end

  def create
    Answer.create!(@params)
  end
end
