require 'rails_helper'
RSpec.describe AnswersDestroyer do
  let(:answer) { instance_double Answer }

  let(:params) { answer }

  subject { AnswersDestroyer.new params }

  describe '#destroy' do
    before { expect(answer).to receive(:destroy!) }

    it { expect { subject.send :destroy }.to_not raise_error }
  end
end
