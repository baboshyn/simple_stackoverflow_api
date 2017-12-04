class SessionsCreator
  include ActiveModel::Validations

  attr_reader :email, :password

  def initialize(params = {})
    @email = params[:email]

    @password = params[:password]
  end

  validate do |model|
    if user
      model.errors.add :password, 'is invalid' unless user.authenticate password
    else
      model.errors.add :email, 'not found'
    end
  end

  def create
    if valid?
      resource = user.sessions.create!
    else
      resource = errors
    end
    resource
  end

  private
  def user
    @user ||= User.find_by email: email
  end
end
