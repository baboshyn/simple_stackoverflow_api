module Factoryable
  def confirmed_user
    instance_double(User, id: 1, unconfirmed?: false, confirmed?: true)
  end

  def unconfirmed_user
    instance_double(User, id: 1, unconfirmed?: true, confirmed?: false)
  end

  def not_author
    instance_double(User, id: 2, unconfirmed?: false, confirmed?: true)
  end

  def answer
    instance_double(Answer, user_id: 1)
  end

  def question
    instance_double(Question, user_id: 1)
  end
end
