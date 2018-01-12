class PubSub
  class << self
    def call
      Redis.current
    end
  end
end
