class QuestionUpdater < ServicesHandler
  def initialize(question, params)
    @resource = question

    @params = params
  end

  def call
    @resource.update(@params)

    super
  end
end
