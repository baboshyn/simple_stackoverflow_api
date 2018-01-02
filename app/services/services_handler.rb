class ServicesHandler
  include Wisper::Publisher

  attr_reader :resource

  def initialize
    raise NotImplementedError
  end

  def call
    action

    broadcast_result
  end

  def broadcast_result
    if resource.valid?
      broadcast :succeeded, resource
    else
      broadcast :failed, resource.errors
    end
  end
end
