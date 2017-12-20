require 'rails_helper'
RSpec.describe QuestionCreator do
  subject { QuestionCreator.new params }

  describe '#create' do
    context '#valid params were passed' do
      let(:params) { attributes_for(:question) }

      let(:question) { instance_double(Question, as_json: params, **params) }

      before { allow(Question).to receive(:create!).with(params).and_return(question) }

      its(:create) { is_expected.to eq question }
    end

    context '#invalid params were passed' do
      let(:question) { Question.new }

      let(:params) { {} }

      before { allow(Question).to receive(:create!).with(params).and_raise(ActiveRecord::RecordInvalid.new(question)) }

      its(:create) { is_expected.to eq question }
    end
  end
end
