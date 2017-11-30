class QuestionsCreator
  include ErrorsHandler

  attr_reader :resource

  def initialize(params = {})
    @params = params

    @resource = Question.new(params)
  end

  def create
    save_resource
  end
end
