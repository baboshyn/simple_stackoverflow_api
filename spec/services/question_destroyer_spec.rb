require 'rails_helper'
RSpec.describe QuestionDestroyer do
  let(:question) { instance_double Question }

  subject { QuestionDestroyer.new question }

  describe '#destroy' do
    before { expect(question).to receive(:destroy!) }

    it('destroys question') { expect { subject.destroy }.to_not raise_error }
  end
end
