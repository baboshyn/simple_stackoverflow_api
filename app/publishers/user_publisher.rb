class UserPublisher
  CHANNEL = 'notifier.email'

  class << self
    def publish(message)
      PubSub.client.publish CHANNEL, message
    end
  end
end
