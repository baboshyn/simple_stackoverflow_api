require 'rails_helper'
RSpec.describe UserSerializer, type: :serializer do
  let(:user) { FactoryGirl.build(:user) }
  let(:serializer) { UserSerializer.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  it 'should have an id that matches' do
    expect(subject['id']).to eq (user.id)
  end


  it 'should have a name that matches' do
    expect(subject['login']).to eq (user.login)
  end

  it 'should have a email that matches' do
    expect(subject['email']).to eq user.email
  end
end
