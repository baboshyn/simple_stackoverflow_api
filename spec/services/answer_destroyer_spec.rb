require 'rails_helper'
RSpec.describe AnswerDestroyer do
  let(:answer) { instance_double Answer }

  subject { AnswerDestroyer.new answer }

  describe '#destroy' do
    before { expect(answer).to receive(:destroy!) }

    it('destroys answer') { expect { subject.destroy }.to_not raise_error }
  end
end
