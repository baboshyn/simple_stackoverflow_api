class AnswersDestroyer
  def initialize params
    @answer = params
  end

  def destroy
    @answer.destroy!
  end
end
