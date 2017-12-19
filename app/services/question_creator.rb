class QuestionCreator
  include Saveable

  def initialize(params = {})
    @resource = Question.new(params)
  end

  def create
    save_resource
  end
end
