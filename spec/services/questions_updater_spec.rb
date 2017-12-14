require 'rails_helper'
RSpec.describe QuestionsUpdater do
  it { is_expected.to be_kind_of(Saveable) }

  let(:params) { attributes_for(:question) }

  let(:question) { instance_double Question }

  subject { QuestionsUpdater.new(question, params) }

  describe '#update' do
    before do
      expect(question).to receive(:assign_attributes).with(params) do
        question.tap { |updated_question| expect(updated_question).to receive(:save!) }
      end
    end

    its(:update) { is_expected.to eq question }
  end
end
