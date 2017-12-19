require 'rails_helper'
RSpec.describe QuestionCreator do
  let(:params) { attributes_for(:question) }

  let(:question) { instance_double(Question, as_json: params, **params) }

  subject { QuestionCreator.new params }

  describe '#create' do
    before { allow(Question).to receive(:create!).with(params).and_return(question) }

    its(:create) { is_expected.to eq question }
  end
end
