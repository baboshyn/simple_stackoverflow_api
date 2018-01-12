class UserPublisher
  CHANNEL = 'notifier.email'

  class << self
    def publish(message)
      PubSub.call.publish CHANNEL, message
    end
  end
end
