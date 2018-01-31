module Factoryable
  def confirmed_user
    build(:user, id: 1, state: 'confirmed')
  end

  def unconfirmed_user
    build(:user, id: 1, state: 'unconfirmed')
  end

  def not_author
    build(:user, id: 2, state: 'confirmed')
  end

  def answer
    build(:answer, user_id: 1)
  end

  def question
    build(:question, user_id: 1)
  end
end
