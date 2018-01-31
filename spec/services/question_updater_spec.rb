require 'rails_helper'

RSpec.describe QuestionUpdater do
  it { is_expected.to be_a ServicesHandler }

  let(:question) { instance_double(Question, as_json: params, **params) }

  let(:params) { attributes_for(:question) }

  let(:errors) { instance_double(ActiveModel::Errors) }

  subject { QuestionUpdater.new(question, params) }

  describe '#call' do
    before { allow(question).to receive(:update).with(params).and_return(question) }

    context 'valid params were passed' do
      before { be_broadcasted_succeeded question }

      it('broadcasts updated question') { expect { subject.call }.to_not raise_error }
    end

    context 'invalid params were passed' do
      before { allow(question).to receive(:errors).and_return(errors) }

      before { be_broadcasted_failed(question, errors) }

      it('broadcasts question.errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
