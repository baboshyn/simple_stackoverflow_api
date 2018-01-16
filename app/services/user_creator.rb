class UserCreator < ServicesHandler
  def initialize(params)
    @resource = User.new(params)
  end

  def call
    user.save

    UserPublisher.publish(message.to_json) if @resource.valid?

    super
  end

  private
  def user
    @resource.email.downcase!

    @resource
  end

  def message
    @resource.attributes.merge(notification: 'registration', token: token)
  end

  def token
    SimpleStackoverflowToken.encode(user_id: @resource.id)
  end
end
