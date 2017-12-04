class AnswersDestroyer
  def initialize answer
    @answer = answer
  end

  def destroy
    @answer.destroy!
  end
end
