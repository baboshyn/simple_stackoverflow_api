module ServiceHandler
  def be_broadcasted_succeeded resource
    allow(resource).to receive(:valid?).and_return(true)

    expect(subject).to receive(:broadcast).with(:succeeded, resource.as_json)
  end

  def be_broadcasted_failed resource, errors
    allow(resource).to receive(:valid?).and_return(false)

    expect(subject).to receive(:broadcast).with(:failed, errors)
  end
end
