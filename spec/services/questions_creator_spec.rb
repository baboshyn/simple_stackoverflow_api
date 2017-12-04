require 'rails_helper'
RSpec.describe QuestionsCreator do
  let(:params) { attributes_for(:question) }
  let(:questions_creator) { QuestionsCreator.new params }
  let(:question) { instance_double(Question, as_json: params, **params) }

  subject { questions_creator }

  describe '#create' do
    before { allow(Question).to receive(:new).with(params).and_return(question) }

    before { allow(question).to receive(:save!).and_return(question) }

    its(:create) { is_expected.to eq question }
  end
end
