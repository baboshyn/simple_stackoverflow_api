require 'rails_helper'
RSpec.describe QuestionUpdater do
  it { is_expected.to be_a ServicesHandler }

  let(:question) { instance_double Question }

  let(:params) { attributes_for(:question) }

  subject { QuestionUpdater.new(question, params) }

  describe '#call' do
    before { allow(question).to receive(:update).with(params).and_return(question) }

    context 'valid params were passed' do
      before { allow(question).to receive(:valid?).and_return(true) }

      before { expect(subject).to receive(:broadcast).with(:succeeded, question) }

      it('broadcasts updated question') { expect { subject.call }.to_not raise_error }
    end

    context 'invalid params were passed' do
      let(:errors) { instance_double(ActiveModel::Errors) }

      before { allow(question).to receive(:errors).and_return(errors) }

      before { allow(question).to receive(:valid?).and_return(false) }

      before { expect(subject).to receive(:broadcast).with(:failed, errors) }

      it('broadcasts question.errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
