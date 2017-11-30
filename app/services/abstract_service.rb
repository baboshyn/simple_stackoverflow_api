class AbstractService
  def save_resource
    resource.save!

    rescue ActiveRecord::RecordInvalid => invalid
    invalid.record
  end
end
