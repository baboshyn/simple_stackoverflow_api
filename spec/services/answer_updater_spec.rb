require 'rails_helper'
RSpec.describe AnswerUpdater do
  let(:params) { attributes_for(:answer) }

  let(:answer) { instance_double Answer }

  subject { AnswerUpdater.new(answer, params) }

  describe '#update' do
    before { allow(answer).to receive(:update!).with(params).and_return(answer) }

    its(:update) { is_expected.to eq answer }
  end
end
