class ServicesHandler
  include Homie

  def initialize
    raise NotImplementedError
  end

  def call
    if @resource.valid?
      broadcast :succeeded, @resource
    else
      broadcast :failed, @resource.errors
    end
  end
end
