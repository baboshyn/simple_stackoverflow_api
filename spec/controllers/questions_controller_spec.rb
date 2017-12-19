require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it { is_expected.to be_kind_of(Authenticatable) }

  it { is_expected.to be_an ApplicationController }

  let(:attrs) { attributes_for(:question) }

  let(:question) { instance_double(Question, id: 1, as_json: attrs, **attrs) }

  let(:user) { instance_double User }

  let(:resource_params) { attributes_for(:question) }

  context 'authentication required' do
    before { sign_in User }

    describe '#create' do
      before do
        allow(QuestionCreator).to receive(:new).with(resource_params) do
          double.tap { |question_creator| allow(question_creator).to receive(:create).and_return(question) }
        end
      end

      context '#parameters for question passed validation'do
        before { allow(question).to receive(:valid?).and_return(true) }

        before { process :create, method: :post, params: { question: resource_params }, format: :json }

        it { expect(response.body).to eq question.to_json }

        it { expect(response).to have_http_status 201 }
      end

      context '#parameters for question did not pass validation'do
        let(:errors) { instance_double(ActiveModel::Errors) }

        before { allow(question).to receive(:valid?).and_return(false) }

        before { allow(question).to receive(:errors).and_return(errors) }

        before { process :create, method: :post, params: { question: resource_params }, format: :json }

        it { expect(response.body).to eq errors.to_json }

        it { expect(response).to have_http_status 422 }
      end
    end

    describe '#update' do
      before { allow(Question).to receive(:find).with('1').and_return(question) }

      before do
        allow(QuestionUpdater).to receive(:new).with(question, resource_params) do
          double.tap { |question_updater| allow(question_updater).to receive(:update).and_return(question) }
        end
      end

      context '#parameters for question passed validation'do
        before { allow(question).to receive(:valid?).and_return(true) }

        before { process :update, method: :patch, params: { id: question.id, question: resource_params }, format: :json }

        it { expect(response.body).to eq question.to_json }

        it { expect(response).to have_http_status 200 }
      end

      context '#parameters for question did not pass validation'do
        let(:errors) { instance_double(ActiveModel::Errors) }

        before { allow(question).to receive(:valid?).and_return(false) }

        before { allow(question).to receive(:errors).and_return(errors) }

        before { process :update, method: :patch, params: { id: question.id, question: resource_params }, format: :json }

        it { expect(response.body).to eq errors.to_json }

        it { expect(response).to have_http_status 422 }
      end
    end


    describe '#destroy' do
      before { allow(Question).to receive(:find).with('1').and_return(question) }

      before do
        expect(QuestionDestroyer).to receive(:new).with(question) do
          double.tap { |question_destroyer| expect(question_destroyer).to receive(:destroy) }
        end
      end

      before { process :destroy, method: :delete, params: { id: question.id }, format: :json }

      it { expect(response).to have_http_status 204 }
    end
  end


  describe '#show' do
    before { allow(Question).to receive(:find).with('1').and_return(question) }

    before { process :show, method: :get, params: { id: question.id }, format: :json }

    it { expect(response).to have_http_status 200 }

    it { expect(response.body).to eq question.to_json }
  end


  describe '#index' do
    let(:params) { attributes_for(:question) }

    let(:collection) { double }

    before { allow(subject).to receive(:params).and_return(params) }

    before do
      allow(QuestionSearcher).to receive(:new).with(params) do
        double.tap { |question_searcher| allow(question_searcher).to receive(:search).and_return(collection) }
      end
    end

    before { process :index, method: :get, params: params, format: :json }

    it { expect(response.body).to eq collection.to_json }

    it { expect(response).to have_http_status 200 }
  end
end
