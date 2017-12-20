require 'rails_helper'
RSpec.describe AnswerUpdater do
  subject { AnswerUpdater.new(answer, params) }

  describe '#update' do
    context '#valid params were passed' do
      let(:params) { attributes_for(:answer) }

      let(:answer) { instance_double Answer }

      before { allow(answer).to receive(:update!).with(params).and_return(answer) }

      its(:update) { is_expected.to eq answer }
    end

    context '#invalid params were passed' do
      let(:answer) { Answer.new }

      let(:params) { {} }

      before { allow(answer).to receive(:update!).with(params).and_raise(ActiveRecord::RecordInvalid.new(answer)) }

      its(:update) { is_expected.to eq answer }
    end
  end
end
