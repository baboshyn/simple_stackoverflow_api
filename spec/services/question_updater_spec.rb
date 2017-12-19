require 'rails_helper'
RSpec.describe QuestionUpdater do
  let(:params) { attributes_for(:question) }

  let(:question) { instance_double Question }

  subject { QuestionUpdater.new(question, params) }

  describe '#update' do

    before { allow(question).to receive(:update!).with(params).and_return(question) }

    its(:update) { is_expected.to eq question }
  end
end
