class AnswersCreator
  include Saveable

  def initialize(params = {})
    @resource = Answer.new(params)
  end

  def create
    save_resource
  end
end
