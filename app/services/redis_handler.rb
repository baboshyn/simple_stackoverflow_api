class RedisHandler
  def initialize
    raise NotImplementedError
  end

  $redis = Redis.new

  class << self
    def publish_confirmation(user)
      $redis.publish 'notificationer.email', { confirmation_token: user.confirmation_token, event_type: 'registration' }.to_json
    end
  end
end
