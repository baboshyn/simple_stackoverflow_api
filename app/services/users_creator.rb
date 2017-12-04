class UsersCreator
  include Saveable

  def initialize(params = {})
    @resource = User.new(params)
  end

  def create
    save_resource
  end
end
