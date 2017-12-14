require 'rails_helper'
RSpec.describe AnswersUpdater do
  it { is_expected.to be_kind_of(Saveable) }

  let(:params) { attributes_for(:answer) }

  let(:answer) { instance_double Answer }

  subject { AnswersUpdater.new(answer, params) }

  describe '#update' do
    before do
      expect(answer).to receive(:assign_attributes).with(params) do
        answer.tap { |updated_answer| expect(updated_answer).to receive(:save!) }
      end
    end

    its(:update) { is_expected.to eq answer }
  end
end
