require 'rails_helper'

RSpec.describe AnswerSerializer, type: :serializer do
  let(:answer) { FactoryBot.build(:answer) }
  let(:serializer) { AnswerSerializer.new(answer) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  it 'should have an id that matches' do
    expect(subject['id']).to eq (answer.id)
  end

  it 'should have an body that matches' do
    expect(subject['body']).to eq (answer.body)
  end
end
