require 'rails_helper'
RSpec.describe AnswerCreator do
  subject { AnswerCreator.new params }

  describe '#create' do
    context '#valid params were passed' do
      let(:params) { { body: "answers body", question_id: "1" } }

      let(:answer) { instance_double(Answer, as_json: params, **params) }

      before do
        allow(Question).to receive(:find).with("1") do
          double.tap do |question|
            allow(question).to receive(:answers) do
              double.tap { |question_answers| allow(question_answers).to receive(:create!).with(params).and_return(answer) }
            end
          end
        end
      end

      its(:create) { is_expected.to eq answer }
    end


    context '#invalid params were passed' do
      let(:answer) { Answer.new }

      let(:params) { { body: " ", question_id: "1" } }

      before do
        expect(Question).to receive(:find).with("1") do
          double.tap do |question|
            expect(question).to receive(:answers) do
              double.tap { |question_answers| allow(question_answers).to receive(:create!).with(params).and_raise(ActiveRecord::RecordInvalid.new(answer)) }
            end
          end
        end
      end

      its(:create) { is_expected.to eq answer }
    end
  end
end
