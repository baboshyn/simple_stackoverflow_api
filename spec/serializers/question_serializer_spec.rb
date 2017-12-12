require 'rails_helper'
RSpec.describe QuestionSerializer, type: :serializer do
  let(:question) { FactoryBot.build(:question) }
  let(:serializer) { QuestionSerializer.new(question) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  subject { JSON.parse(serialization.to_json) }

  it 'should have an id that matches' do
    expect(subject['id']).to eq question.id
  end

  it 'should have a title that matches' do
    expect(subject['title']).to eq question.title
  end

  it 'should have a body that matches' do
    expect(subject['body']).to eq question.body
  end
end
