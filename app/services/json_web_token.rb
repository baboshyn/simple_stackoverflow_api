class JsonWebToken
  class << self

    AUTH_SECRET = Rails.application.secrets.secret_key_base

    def encode(payload)
      payload[:exp] = 1.day.from_now.to_i
      JWT.encode(
        payload,
        AUTH_SECRET)
    end

    def decode(token)
      JWT.decode(token,
        AUTH_SECRET)
    end
  end
end