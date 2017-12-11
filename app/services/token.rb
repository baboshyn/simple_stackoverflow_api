class Token
  include ActiveModel::Validations

  attr_reader :login, :password

  def initialize(params = {})
    @email = params[:login]

    @password = params[:password]
  end

  validate do |model|
    if user
      model.errors.add :password, 'is invalid' unless user.authenticate password
    else
      model.errors.add :login, 'not found'
    end
  end

  def save
    if valid?
      JsonWebToken.encode({ user: user.id })
    else
      errors
    end
  end

  private
  def user
    user = User.find_by login: login
  end
end
