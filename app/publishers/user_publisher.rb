class UserPublisher
  CHANNEL = 'notifier.email'

  class << self
    def publish(message)
      Redis.current.publish CHANNEL, message
    end
  end
end
