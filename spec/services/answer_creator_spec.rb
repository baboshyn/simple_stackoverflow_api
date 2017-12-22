require 'rails_helper'
RSpec.describe AnswerCreator do
  subject { AnswerCreator.new params, question }

  let(:question) { instance_double(Question) }

  describe '#create' do
    context '#valid params were passed' do
      let(:params) { attributes_for(:answer) }

      let(:answer) { instance_double(Answer, as_json: params, **params) }

      before do
        allow(question).to receive(:answers) do
          double.tap { |question_answers| allow(question_answers).to receive(:create!).with(params).and_return(answer) }
        end
      end

      its(:create) { is_expected.to eq answer }
    end


    context '#invalid params were passed' do
      let(:answer) { Answer.new }

      let(:params) { { } }

      before do
        allow(question).to receive(:answers) do
          double.tap { |question_answers| allow(question_answers).to receive(:create!).with(params)
                                                                 .and_raise(ActiveRecord::RecordInvalid.new(answer)) }
        end
      end

      its(:create) { is_expected.to eq answer }
    end
  end
end
