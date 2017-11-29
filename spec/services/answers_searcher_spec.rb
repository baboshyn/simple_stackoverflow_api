require 'rails_helper'
RSpec.describe AnswersSearcher do
  let(:answers_searcher) { AnswersSearcher.new params }

  subject { answers_searcher }

  let(:result_all) {double}

  before { allow(Answer).to receive(:all).and_return(result_all) }

  describe '#search' do
    context '#parent_id.present?'do
      let(:params) { { parent_id: '1' } }

      before { allow(result_all).to receive(:where).with(question_id: '1').and_return(:result) }

      # its(:search) { is_expected.to eq :result }
    end

    context '#body.present?'do
      let(:params) { { body: 'body' } }

      before { allow(result_all).to receive(:where).with('body ILIKE?', "%body%").and_return(:result) }

      its(:search) { is_expected.to eq :result }
    end

    context '#all' do
      let(:params) { { } }

      its(:search) { is_expected.to eq result_all }
    end
  end
end
