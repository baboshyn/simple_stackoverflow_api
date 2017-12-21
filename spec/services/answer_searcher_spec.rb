require 'rails_helper'
RSpec.describe AnswerSearcher do
  let(:result_all) {double}

  subject { AnswerSearcher.new params }

  before do
    allow(Question).to receive(:find).with(params[:question_id]) do
      double.tap { |question| allow(question).to receive(:answers).and_return(result_all) }
    end
  end

  describe '#search' do
    context '#searching answers on the question by body' do
      let(:result) { double }

      let(:params) { { body: 'body', question_id: "1" } }

      before { allow(result_all).to receive(:where).with('body ILIKE?', "%body%").and_return(result) }

      its(:search) { is_expected.to eq result }
    end

    context '#show all answers on the question' do
      let(:params) { { question_id: "1" } }

      its(:search) { is_expected.to eq result_all }
    end
  end
end
