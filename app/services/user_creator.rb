class UserCreator < ServicesHandler
  def initialize(params = {})
    @params = params
  end

  def action
    @resource = User.create(@params)
  end
end
