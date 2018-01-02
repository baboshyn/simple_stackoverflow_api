class UserCreator < ServicesHandler
  def initialize(params = {})
    @params = params
  end

  def call
    @resource = User.create(@params)

    super
  end
end
