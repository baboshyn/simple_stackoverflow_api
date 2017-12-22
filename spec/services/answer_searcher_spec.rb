require 'rails_helper'
RSpec.describe AnswerSearcher do
  let(:result_all) {double}

  let(:parent) { instance_double(Question) }

  subject { AnswerSearcher.new params, parent }

  before { allow(parent).to receive(:answers).and_return(result_all) }

  describe '#search' do
    context '#searching answers on the question by body' do
      let(:result) { double }

      let(:params) { { body: 'body' } }

      before { allow(result_all).to receive(:where).with('body ILIKE?', "%body%").and_return(result) }

      its(:search) { is_expected.to eq result }
    end

    context '#show all answers on the question' do
      let(:params) { {} }

      its(:search) { is_expected.to eq result_all }
    end
  end
end
