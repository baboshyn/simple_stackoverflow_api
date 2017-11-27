require 'rails_helper'
RSpec.describe AnswersDestroyer do
  let(:answer) { instance_double Answer }
  let(:params) { answer }
  let(:answers_destroyer) { AnswersDestroyer.new params }

  subject { answers_destroyer }

  describe '#destroy' do
    before { expect(answer).to receive(:destroy!).and_return(true) }

    its(:destroy) { is_expected.to eq true }
  end
end
