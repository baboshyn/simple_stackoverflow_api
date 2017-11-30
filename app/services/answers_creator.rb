class AnswersCreator < AbstractService
  def initialize(params = {})
    @params = params
  end

  def resource
    @resource = Answer.new(@params)
  end

  def create
    save_resource

    @resource
  end
end
