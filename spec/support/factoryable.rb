module Factoryable
  def confirmed_user
    create(:user, id: 1, state: 'confirmed')
  end

  def unconfirmed_user
    create(:user, id: 1, state: 'unconfirmed')
  end

  def not_author
    create(:user, id: 2, state: 'confirmed')
  end

  def answer
    create(:answer, user_id: 1)
  end

  def question
    create(:question, user_id: 1)
  end
end
