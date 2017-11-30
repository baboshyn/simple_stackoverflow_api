class AnswersUpdater
  include ErrorsHandable

  attr_reader :resource

  def initialize(answer, params)
    @resource = answer

    @params = params
  end


  def update
    @resource.assign_attributes(@params)

    save_resource
  end
end
