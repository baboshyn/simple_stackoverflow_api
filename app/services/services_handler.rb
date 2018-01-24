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

  private
  def serialized_resource
    ActiveModelSerializers::SerializableResource.new(@resource).as_json
  end
end
