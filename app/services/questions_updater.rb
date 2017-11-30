class QuestionsUpdater < AbstractService
  def initialize(question, params)
    @question = question

    @params = params
  end

  def resource
    @question.assign_attributes(@params)

    @question
  end

  def update
    save_resource

    @question
  end
end
