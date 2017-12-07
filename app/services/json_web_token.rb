class JsonWebToken
  class << self

    AUTH_SECRET = Rails.application.secrets.secret_key_base

    def issue(payload)
      payload.reverse_merge!(meta)
      JWT.encode(
        payload,
        AUTH_SECRET)
    end

    def decode(token)
      JWT.decode(token,
        AUTH_SECRET)
    end

    def meta
      {
        exp: 1.minutes.from_now.to_i
      }
    end
  end
end
