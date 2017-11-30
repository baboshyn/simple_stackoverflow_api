class QuestionsCreator < AbstractService
  def initialize(params = {})
    @params = params
  end

  def resource
    @resource = Question.new(@params)
  end

  def create
    save_resource

    @resource
  end
end
