require 'rails_helper'
RSpec.describe AnswerUpdater do
  it { is_expected.to be_a ServicesHandler }

  let(:params) { attributes_for(:answer) }

  let(:answer) { instance_double Answer }

  subject { AnswerUpdater.new(answer, params) }

  describe '#call' do
    before { allow(answer).to receive(:update).with(params).and_return(answer) }

    context 'valid params were passed' do
      before { allow(answer).to receive(:valid?).and_return(true) }

      before { expect(subject).to receive(:broadcast).with(:succeeded, answer) }

      it('broadcasts updated answer') { expect { subject.call }.to_not raise_error }
    end

    context 'invalid params were passed' do
      let(:errors) { instance_double(ActiveModel::Errors) }

      before { allow(answer).to receive(:errors).and_return(errors) }

      before { allow(answer).to receive(:valid?).and_return(false) }

      before { expect(subject).to receive(:broadcast).with(:failed, errors) }

      it('broadcasts answer.errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
