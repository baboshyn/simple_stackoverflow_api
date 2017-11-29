class UsersCreator
  def initialize(params = {})
    @params = params
  end

  def create
    User.create!(@params)

    rescue ActiveRecord::RecordInvalid => invalid
    invalid
  end
end
