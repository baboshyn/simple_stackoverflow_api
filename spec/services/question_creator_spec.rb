require 'rails_helper'
RSpec.describe QuestionCreator do
  it { is_expected.to be_kind_of(Saveable) }

  let(:params) { attributes_for(:question) }

  let(:question) { instance_double(Question, as_json: params, **params) }

  subject { QuestionCreator.new params }

  describe '#create' do
    before do
      expect(Question).to receive(:new).with(params) do
        question.tap { |initialized_question| expect(initialized_question).to receive(:save!) }
      end
    end

    its(:create) { is_expected.to eq question }
  end
end
