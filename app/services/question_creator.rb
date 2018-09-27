class QuestionCreator < ServicesHandler
  def initialize(params)
    @params = params
  end

  def call
    @resource = Question.create(@params)

    super
  end
end
