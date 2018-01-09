class ConfirmationHandler
  EVENT   = 'registration'
  CHANNEL = 'notificationer.email'

  class << self
    def publish_confirmation(user)
      Redis.current.publish CHANNEL, { confirmation_token: user.confirmation_token,
                                        first_name: user.first_name,
                                         last_name: user.last_name,
                                             email: user.email,
                                        event_type: EVENT }.to_json
    end
  end
end
