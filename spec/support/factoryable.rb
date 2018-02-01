module Factoryable
  def confirmed_user
    instance_double(User, id: 1, state: 'confirmed')
  end

  def unconfirmed_user
    instance_double(User, id: 1, state: 'unconfirmed')
  end

  def not_author
    instance_double(User, id: 2, state: 'confirmed')
  end

  def answer
    instance_double(Answer, user_id: 1)
  end

  def question
    instance_double(Question, user_id: 1)
  end
end
