require 'rails_helper'
RSpec.describe QuestionDestroyer do
  let(:question) { instance_double Question }

  let(:params) { question }

  subject { QuestionDestroyer.new params }

  describe '#destroy' do
    before { expect(question).to receive(:destroy!) }

    it { expect { subject.send :destroy }.to_not raise_error }
  end
end
