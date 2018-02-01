class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  private
  def valid_user?
    user.state == 'confirmed'
  end

  def user_is_author?
    user.id == record.user_id
  end
end
