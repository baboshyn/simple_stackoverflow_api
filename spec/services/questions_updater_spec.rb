require 'rails_helper'
RSpec.describe QuestionsUpdater do
  let(:params) { attributes_for(:question) }
  let(:question) { instance_double Question }
  let(:questions_updater) { QuestionsUpdater.new(question, params) }

  subject { questions_updater }

  describe '#update' do
    before { allow(question).to receive(:assign_attributes).with(params).and_return(question) }

    before { allow(question).to receive(:save!).and_return(question) }

    its(:update) { is_expected.to eq question }
  end
end
