require 'rails_helper'
RSpec.describe QuestionUpdater do
  subject { QuestionUpdater.new(question, params) }

  describe '#update' do
    context '#valid params were passed' do
      let(:question) { instance_double Question }

      let(:params) { attributes_for(:question) }

      before { allow(question).to receive(:update!).with(params).and_return(question) }

      it('returns updated question') { expect(subject.update).to eq question }
    end

    context '#invalid params were passed' do
      let(:question) { Question.new }

      let(:params) { {} }

      before { allow(question).to receive(:update!).with(params).and_raise(ActiveRecord::RecordInvalid.new(question)) }

      it('returns errors') { expect(subject.update).to eq question }
    end
  end
end
