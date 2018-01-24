class AnswerUpdater < ServicesHandler
  def initialize(answer, params)
    @resource = answer

    @params = params.except(:question_id)
  end


  def call
    @resource.update(@params)

    super
  end
end
