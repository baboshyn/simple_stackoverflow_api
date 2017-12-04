class QuestionsUpdater
  include Saveable

  def initialize(question, params)
    @resource = question

    @params = params
  end


  def update
    @resource.assign_attributes(@params)

    save_resource
  end
end
