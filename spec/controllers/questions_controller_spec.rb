require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it { is_expected.to be_kind_of(Authenticatable) }

  it { is_expected.to be_an ApplicationController }

  let(:attrs) { attributes_for(:question) }
  let(:question) { instance_double(Question, id: 1, as_json: attrs, **attrs) }
  let(:user) { instance_double User }

  context 'authentication required' do
    before { sign_in User }

    describe '#create' do
      let(:resource_params) { attributes_for(:question) }

      before do
        allow(QuestionsCreator).to receive(:new).with(permit!(resource_params)) do
          double.tap { |questions_creator| allow(questions_creator).to receive(:create).and_return(question) }
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
      let(:resource_params) { attributes_for(:question) }

      before { allow(Question).to receive(:find).with('1').and_return(question) }

      before do
        allow(QuestionsUpdater).to receive(:new).with(question, permit!(resource_params)) do
          double.tap { |questions_updater| allow(questions_updater).to receive(:update).and_return(question) }
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
        expect(QuestionsDestroyer).to receive(:new).with(question) do
          double.tap { |questions_destroyer| expect(questions_destroyer).to receive(:destroy) }
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

    before { allow(subject).to receive(:params).and_return(params) }

    before do
      allow(QuestionsSearcher).to receive(:new).with(params) do
        double.tap { |questions_searcher| allow(questions_searcher).to receive(:search).and_return(:collection) }
      end
    end

    before { process :index, method: :get, params: params, format: :json }

    it { expect(response.body).to eq :collection.to_json }

    it { expect(response).to have_http_status 200 }
  end
end
