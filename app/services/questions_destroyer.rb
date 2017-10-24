class QuestionsDestroyer
  def initialize params
    @question = params
  end

  def destroy
    @question.destroy!
  end
end
