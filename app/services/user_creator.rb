class UserCreator < ServicesHandler
  def initialize(params)
    @params = params
  end

  def call
    @resource = User.new(@params)

    @resource.email&.downcase!

    UserPublisher.publish(message.to_json) if @resource.save

    super
  end

  private
  def message
    serialized_resource.merge(notification: 'registration', token: token)
  end

  def token
    SimpleStackoverflowToken.encode(user_id: @resource.id)
  end
end
