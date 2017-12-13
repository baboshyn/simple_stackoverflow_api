require 'rails_helper'
RSpec.describe AnswersUpdater do
  it { is_expected.to be_kind_of(Saveable) }

  let(:params) { attributes_for(:answer) }
  let(:answer) { instance_double Answer }
  let(:answers_updater) { AnswersUpdater.new(answer, params) }

  subject { answers_updater }

  describe '#update' do
    before { allow(answer).to receive(:assign_attributes).with(params).and_return(answer) }

    before { allow(answer).to receive(:save!).and_return(answer) }

    its(:update) { is_expected.to eq answer }
  end
end
