class AnswerSearcher
  def initialize(params = {}, parent)
    @body = params[:body]

    @result = parent.answers
  end

  def search
    @result = @result.where('body ILIKE?', "%#{ @body }%") if @body.present?

    @result
  end
end
