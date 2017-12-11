class Token
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

  def save
    if valid?
      JsonWebToken.encode({ user: user.id })
    else
      errors
    end
  end

  private
  def user
    user = User.find_by email: email
  end
end
