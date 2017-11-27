require 'rails_helper'
RSpec.describe QuestionsDestroyer do
  let(:question) { instance_double Question }
  let(:params) { question }
  let(:questions_destroyer) { QuestionsDestroyer.new params }

  subject { questions_destroyer }

  describe '#destroy' do
    before { expect(question).to receive(:destroy!).and_return(true) }

    its(:destroy) { is_expected.to eq true }
  end
end
