require 'rails_helper'
RSpec.describe AnswersCreator do
  it { is_expected.to be_kind_of(Saveable) }

  let(:params) { attributes_for(:answer) }
  let(:answer) { instance_double(Answer, as_json: params, **params) }

  subject { AnswersCreator.new params }

  describe '#create' do
    before do
      expect(Answer).to receive(:new).with(params) do
        answer.tap { |initialized_answer| expect(initialized_answer).to receive(:save!) }
      end
    end

    its(:create) { is_expected.to eq answer }
  end
end
