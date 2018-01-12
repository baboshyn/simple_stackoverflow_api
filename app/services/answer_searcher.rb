class AnswerSearcher
  def initialize(question, params = {})
    @body = params[:body]

    @result = question.answers
  end

  def search
    @result = @result.where('body ILIKE?', "%#{ @body }%") if @body.present?

    @result
  end
end
