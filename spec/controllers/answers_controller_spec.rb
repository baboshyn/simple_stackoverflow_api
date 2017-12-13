require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it { is_expected.to be_kind_of(Authenticatable) }

  it { is_expected.to be_an ApplicationController }

  let(:attrs) { attributes_for(:answer) }
  let(:answer) { instance_double(Answer, id: 1, as_json: attrs, **attrs) }
  let(:user) { instance_double User }

  context 'authentication required' do
    before { sign_in User }

    describe '#create' do
      let(:resource_params) { attributes_for(:answer) }

      before do
        allow(AnswersCreator).to receive(:new).with(permit!(resource_params)) do
          double.tap { |answers_creator| allow(answers_creator).to receive(:create).and_return(answer) }
        end
      end

      context '#parameters for qanswer passed validation'do
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
      let(:resource_params) { attributes_for(:answer) }

      before { allow(Answer).to receive(:find).with('1').and_return(answer) }

      before do
        allow(AnswersUpdater).to receive(:new).with(answer, permit!(resource_params)) do
          double.tap { |answers_updater| allow(answers_updater).to receive(:update).and_return(answer) }
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
        expect(AnswersDestroyer).to receive(:new).with(answer) do
          double.tap { |answers_destroyer| expect(answers_destroyer).to receive(:destroy) }
        end
      end

      before { process :destroy, method: :delete, params: { id: answer.id }, format: :json }

      it { expect(response).to have_http_status 204 }
    end
  end


  describe '#show' do
    before { allow(Answer).to receive(:find).with('1').and_return(answer) }

    before { process :show, method: :get, params: { id: answer.id }, format: :json }

    it { expect(response).to have_http_status 200 }

    it { expect(response.body).to eq answer.to_json }
  end


  describe '#index' do
    let(:params) { attributes_for(:answer) }

    before { allow(subject).to receive(:params).and_return(params) }

    before do
      allow(AnswersSearcher).to receive(:new).with(params) do
        double.tap { |answers_searcher| allow(answers_searcher).to receive(:search).and_return(:collection) }
      end
    end

    before { process :index, method: :get, params: params, format: :json }

    it { expect(response.body).to eq :collection.to_json }

    it { expect(response).to have_http_status 200 }
  end
end
