class QuestionsDestroyer
  def initialize question
    @question = question
  end

  def destroy
    @question.destroy!
  end
end
