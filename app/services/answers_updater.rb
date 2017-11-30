class AnswersUpdater < AbstractService
  def initialize(answer, params)
    @answer = answer

    @params = params
  end

  def resource
    @answer.assign_attributes(@params)

    @answer
  end

  def update
    save_resource

    @answer
  end
end
