class QuestionsCreator
  def initialize(params = {})
    @params = params
  end

  def create
    Question.create!(@params)
  end
end
