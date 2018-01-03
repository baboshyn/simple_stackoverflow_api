class AnswerCreator < ServicesHandler
  def initialize(params = {}, question)
    @params = params

    @question = question
  end

  def call
    @resource = @question.answers.create(@params)

    super
  end
end
