class QuestionsSearcher
  def initialize(params = {})
    @title = params[:title]

    @body = params[:body]

    @result = Question.all
  end

  def search
    @result = @result.where('title ILIKE?', "%#{ @title }%") if @title.present?

    @result = @result.where('body ILIKE?', "%#{ @body }%") if @body.present?

    @result
  end
end
