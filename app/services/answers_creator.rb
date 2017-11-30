class AnswersCreator
  include ErrorsHandable

  attr_reader :resource

  def initialize(params = {})
    @params = params

    @resource = Answer.new(@params)
  end

  def create
    save_resource
  end
end
