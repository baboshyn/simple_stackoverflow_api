module Saveable
  def save_resource
    @resource.save!

    @resource
    rescue ActiveRecord::RecordInvalid => invalid
    invalid.record
  end
end
