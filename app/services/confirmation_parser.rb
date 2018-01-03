class ConfirmationParser
  def initialize
    raise NotImplementedError
  end

  class << self
    def parse(confirmation_token)
      payload, _ = SimpleStackoverflowToken.decode(confirmation_token)

      payload['user_id']
    end
  end
end
