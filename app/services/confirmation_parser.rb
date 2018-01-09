class ConfirmationParser
  class << self
    def parse(confirmation_token)
      payload, _ = SimpleStackoverflowToken.decode(confirmation_token)

      payload['user_id'] if payload
    end
  end
end
