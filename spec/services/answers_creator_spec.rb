require 'rails_helper'
RSpec.describe AnswersCreator do
  let(:params) { attributes_for(:answer) }
  let(:answers_creator) { AnswersCreator.new params }
  let(:answer) { instance_double(Answer, as_json: params, **params) }

  subject { answers_creator }

  describe '#create' do
    before { allow(Answer).to receive(:new).with(params).and_return(answer) }

    before { allow(answer).to receive(:save!).and_return(answer) }

    its(:create) { is_expected.to eq answer }
  end
end
