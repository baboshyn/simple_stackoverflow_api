class UserCreator < ServicesHandler
  def initialize(params)
    @params = params
  end

  def call
    @resource = User.create(@params)

    UserPublisher.publish(message.to_json) if @resource.valid?

    super
  end

  private
  def message
    @resource.attributes.merge(notification: 'registration', token: token)
  end

  def token
    SimpleStackoverflowToken.encode(user_id: @resource.id)
  end
end
