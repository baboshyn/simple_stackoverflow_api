require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it { is_expected.to be_kind_of(Authenticatable) }

  it { is_expected.to be_an ApplicationController }

  let(:attrs) { attributes_for(:answer) }

  let(:answer) { instance_double(Answer, id: 1, as_json: attrs, **attrs) }

  let(:user) { instance_double User }

  let(:resource_params) { attributes_for(:answer) }

  context 'authentication required' do
    before { sign_in User }

    describe '#create' do
      before do
        allow(AnswerCreator).to receive(:new).with(resource_params) do
          double.tap { |answer_creator| allow(answer_creator).to receive(:create).and_return(answer) }
        end
      end

      context '#parameters for answer passed validation'do
        before { allow(answer).to receive(:valid?).and_return(true) }

        before { process :create, method: :post, params: { answer: resource_params }, format: :json }

        it { expect(response.body).to eq answer.to_json }

        it { expect(response).to have_http_status 201 }
      end

      context '#parameters for answer did not pass validation'do
        let(:errors) { instance_double(ActiveModel::Errors) }

        before { allow(answer).to receive(:valid?).and_return(false) }

        before { allow(answer).to receive(:errors).and_return(errors) }

        before { process :create, method: :post, params: { answer: resource_params }, format: :json }

        it { expect(response.body).to eq errors.to_json }

        it { expect(response).to have_http_status 422 }
      end
    end


    describe '#update' do
      before { allow(Answer).to receive(:find).with('1').and_return(answer) }

      before do
        allow(AnswerUpdater).to receive(:new).with(answer, resource_params) do
          double.tap { |answer_updater| allow(answer_updater).to receive(:update).and_return(answer) }
        end
      end

      context '#parameters for answer passed validation'do
        before { allow(answer).to receive(:valid?).and_return(true) }

        before { process :update, method: :patch, params: { id: answer.id, answer: resource_params }, format: :json }

        it { expect(response.body).to eq answer.to_json }

        it { expect(response).to have_http_status 200 }
      end

      context '#parameters for answer did not pass validation'do
        let(:errors) { instance_double(ActiveModel::Errors) }

        before { allow(answer).to receive(:valid?).and_return(false) }

        before { allow(answer).to receive(:errors).and_return(errors) }

        before { process :update, method: :patch, params: { id: answer.id, answer: resource_params }, format: :json }

        it { expect(response.body).to eq errors.to_json }

        it { expect(response).to have_http_status 422 }
      end
    end

    describe '#destroy' do
      before { allow(Answer).to receive(:find).with('1').and_return(answer) }

      before do
        expect(AnswerDestroyer).to receive(:new).with(answer) do
          double.tap { |answer_destroyer| expect(answer_destroyer).to receive(:destroy) }
        end
      end

      before { process :destroy, method: :delete, params: { id: answer.id }, format: :json }

      it { expect(response).to have_http_status 204 }
    end
  end


  describe '#index' do
    let(:params) { attributes_for(:answer) }

    let(:collection) { double }

    before { allow(subject).to receive(:params).and_return(params) }

    before do
      allow(AnswerSearcher).to receive(:new).with(params) do
        double.tap { |answer_searcher| allow(answer_searcher).to receive(:search).and_return(collection) }
      end
    end

    before { process :index, method: :get, params: params, format: :json }

    it { expect(response.body).to eq collection.to_json }

    it { expect(response).to have_http_status 200 }
  end
end
