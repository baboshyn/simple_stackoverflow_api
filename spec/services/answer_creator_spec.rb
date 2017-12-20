require 'rails_helper'
RSpec.describe AnswerCreator do
  subject { AnswerCreator.new params }

  describe '#create' do
    context '#valid params were passed' do
      let(:params) { attributes_for(:answer) }

      let(:answer) { instance_double(Answer, as_json: params, **params) }

      before { allow(Answer).to receive(:create!).with(params).and_return(answer) }

      its(:create) { is_expected.to eq answer }
    end

    context '#invalid params were passed' do
      let(:answer) { Answer.new }

      let(:params) { {} }

      before { allow(Answer).to receive(:create!).with(params).and_raise(ActiveRecord::RecordInvalid.new(answer)) }

      its(:create) { is_expected.to eq answer }
    end
  end
end
