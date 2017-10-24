class AnswersSearcher
  def initialize(params = {})
    @body = params[:body]

    @parent_id = params[:question_id]

    @result = Answer.all
  end

  def search
    @result = @result.where(question_id: @parent_id) if @parent_id.present?

    @result = @result.where('body ILIKE?', "%#{ @body }%") if @body.present?

    @result
  end
end
