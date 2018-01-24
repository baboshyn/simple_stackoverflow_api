class AnswerUpdater < ServicesHandler
  def initialize(answer, params)
    @resource = answer

    @params = params
  end


  def call
    @resource.update(@params)

    super
  end
end
