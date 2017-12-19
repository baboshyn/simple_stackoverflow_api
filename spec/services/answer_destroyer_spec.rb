require 'rails_helper'
RSpec.describe AnswerDestroyer do
  let(:answer) { instance_double Answer }

  let(:params) { answer }

  subject { AnswerDestroyer.new params }

  describe '#destroy' do
    before { expect(answer).to receive(:destroy!) }

    it { expect { subject.send :destroy }.to_not raise_error }
  end
end
