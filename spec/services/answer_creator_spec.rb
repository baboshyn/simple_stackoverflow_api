require 'rails_helper'
RSpec.describe AnswerCreator do
  let(:params) { attributes_for(:answer) }

  let(:answer) { instance_double(Answer, as_json: params, **params) }

  subject { AnswerCreator.new params }

  describe '#create' do
    before { allow(Answer).to receive(:create!).with(params).and_return(answer) }

    its(:create) { is_expected.to eq answer }
  end
end
