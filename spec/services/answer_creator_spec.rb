require 'rails_helper'
RSpec.describe AnswerCreator do
  it { is_expected.to be_a ServicesHandler }

  subject { AnswerCreator.new params, question }

  let(:question) { instance_double(Question) }

  let(:params) { attributes_for(:answer) }

  let(:answer) { instance_double(Answer, as_json: params, **params) }

  describe '#call' do
    before do
      allow(question).to receive(:answers) do
        double.tap { |question_answers| allow(question_answers).to receive(:create).with(params).and_return(answer) }
      end
    end

    context 'valid params were passed' do
      before { allow(answer).to receive(:valid?).and_return(true) }

      before { expect(subject).to receive(:broadcast).with(:succeeded, answer) }

      it('broadcasts created answer') { expect { subject.call }.to_not raise_error }
    end

    context 'invalid params were passed' do
      let(:errors) { instance_double(ActiveModel::Errors) }

      before { allow(answer).to receive(:errors).and_return(errors) }

      before { allow(answer).to receive(:valid?).and_return(false) }

      before { expect(subject).to receive(:broadcast).with(:failed, errors) }

      it('broadcasts question.errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
