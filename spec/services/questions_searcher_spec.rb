require 'rails_helper'
RSpec.describe QuestionsSearcher do
  let(:questions_searcher) { QuestionsSearcher.new params }

  subject { questions_searcher }

  let(:result_all) {double}

  before { expect(Question).to receive(:all).and_return(result_all) }

  describe '#search' do
    context '#title.present?'do
      let(:params) { { title: 'title' } }

      before { expect(result_all).to receive(:where).with('title ILIKE?', "%title%").and_return(:result) }

      its(:search) { is_expected.to eq :result }
    end

    context '#body.present?'do
      let(:params) { { body: 'body' } }

      before { expect(result_all).to receive(:where).with('body ILIKE?', "%body%").and_return(:result) }

      its(:search) { is_expected.to eq :result }
    end

    context '#all' do
      let(:params) { { } }

      its(:search) { is_expected.to eq result_all }
    end
  end
end
