require 'rails_helper'
RSpec.describe QuestionSearcher do
  let(:result_all) {double}

  subject { QuestionSearcher.new params }

  before { allow(Question).to receive(:all).and_return(result_all) }

  describe '#search' do
    context '#searching questions by title'do
      let(:params) { { title: 'title' } }

      before { allow(result_all).to receive(:where).with('title ILIKE?', "%title%").and_return(:result) }

      its(:search) { is_expected.to eq :result }
    end

    context '#searching questions by body 'do
      let(:params) { { body: 'body' } }

      before { allow(result_all).to receive(:where).with('body ILIKE?', "%body%").and_return(:result) }

      its(:search) { is_expected.to eq :result }
    end

    context '#show all questions' do
      let(:params) { { } }

      its(:search) { is_expected.to eq result_all }
    end
  end
end
