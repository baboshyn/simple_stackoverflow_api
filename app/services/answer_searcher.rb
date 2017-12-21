class AnswerSearcher
  def initialize(params = {})
    @body = params[:body]

    parent = Question.find(params[:question_id])

    @result = parent.answers
  end

  def search
    @result = @result.where('body ILIKE?', "%#{ @body }%") if @body.present?

    @result
  end
end
