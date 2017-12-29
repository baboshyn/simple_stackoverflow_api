require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:attrs) { attributes_for(:question) }

  let(:question) { instance_double(Question, id: 1, as_json: attrs, **attrs) }

  let(:user) { instance_double User }

  let(:resource_params) { attributes_for(:question) }

  let(:question_id) { '1' }

  before { allow(Question).to receive(:find).with(question_id).and_return(question) }

  describe 'POST #create' do
    context 'user authenticated' do
      before { sign_in user }

      before do
        allow(QuestionCreator).to receive(:new).with(resource_params) do
          double.tap { |question_creator| allow(question_creator).to receive(:create).and_return(question) }
        end
      end

      context 'parameters for question passed validation'do
        before { allow(question).to receive(:valid?).and_return(true) }

        before { process :create, method: :post, params: { question: resource_params }, format: :json }

        it('returns created question') { expect(response.body).to eq question.to_json }

        it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
      end

      context 'parameters for question did not pass validation'do
        let(:errors) { instance_double(ActiveModel::Errors) }

        before { allow(question).to receive(:valid?).and_return(false) }

        before { allow(question).to receive(:errors).and_return(errors) }

        before { process :create, method: :post, params: { question: resource_params }, format: :json }

        it('returns errors') { expect(response.body).to eq errors.to_json }

        it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
      end

      context 'bad request was sent' do
        before { process :create, method: :post, params: { ' ': resource_params }, format: :json }

        it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
      end
    end

    context 'user not authenticated' do
      before { process :create, method: :post, params: { question: resource_params }, format: :json }

      it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }
    end
  end

  describe 'PATCH #update' do
    context 'user authenticated' do
      before { sign_in user }

      context 'question was found' do
        before do
          allow(QuestionUpdater).to receive(:new).with(question, resource_params) do
            double.tap { |question_updater| allow(question_updater).to receive(:update).and_return(question) }
          end
        end

        context 'parameters for question passed validation' do
          before { allow(question).to receive(:valid?).and_return(true) }

          before { process :update, method: :patch, params: { id: question_id, question: resource_params }, format: :json }

          it('updated question') { expect(response.body).to eq question.to_json }

          it('returns HTTP Status Code 200') { expect(response).to have_http_status 200 }
        end

        context 'parameters for question did not pass validation' do
          let(:errors) { instance_double(ActiveModel::Errors) }

          before { allow(question).to receive(:valid?).and_return(false) }

          before { allow(question).to receive(:errors).and_return(errors) }

          before { process :update, method: :patch, params: { id: question_id, question: resource_params }, format: :json }

          it('returns errors') { expect(response.body).to eq errors.to_json }

          it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
        end

        context 'bad request was sent' do
          before { process :update, method: :patch, params: { id: question_id, ' ': resource_params }, format: :json }

          it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
        end
      end

      context 'question was not found' do
        before { expect(Question).to receive(:find).with("0").and_raise ActiveRecord::RecordNotFound }

        before { process :update, method: :patch, params: { id: 0, question: resource_params }, format: :json }

        it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
      end
    end

    context 'user not authenticated' do
      before { process :update, method: :patch, params: { id: question_id, question: resource_params }, format: :json }

      it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }
    end
  end

  describe 'DELETE #destroy' do
    context 'user authenticated' do
      before { sign_in user }

      context 'question was found' do
        before do
          expect(QuestionDestroyer).to receive(:new).with(question) do
            double.tap { |question_destroyer| expect(question_destroyer).to receive(:destroy) }
          end
        end

        before { process :destroy, method: :delete, params: { id: question_id }, format: :json }

        it('returns HTTP Status Code 204') { expect(response).to have_http_status 204 }
      end

      context 'question was not found' do
        before { expect(Question).to receive(:find).with('0').and_raise ActiveRecord::RecordNotFound }

        before { process :destroy, method: :delete, params: {id: 0}, format: :json }

        it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
      end
    end

    context 'user not authencticated' do
      before { process :destroy, method: :delete, params: { id: question_id }, format: :json }

      it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }
    end
  end

  describe 'GET #show' do
    context 'question was found' do
      before { process :show, method: :get, params: { id: question_id }, format: :json }

      it('returns HTTP Status Code 200') { expect(response).to have_http_status 200 }

      it('returns searched question') { expect(response.body).to eq question.to_json }
    end

    context 'question was not found' do
      before { expect(Question).to receive(:find).with('0').and_raise ActiveRecord::RecordNotFound }

      before { process :show, method: :get, params: {id: 0}, format: :json }

      it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
    end
  end

  describe 'GET #index' do
    let(:params) { attributes_for(:question) }

    let(:collection) { double }

    before { allow(subject).to receive(:params).and_return(params) }

    before do
      allow(QuestionSearcher).to receive(:new).with(params) do
        double.tap { |question_searcher| allow(question_searcher).to receive(:search).and_return(collection) }
      end
    end

    before { process :index, method: :get, params: params, format: :json }

    it('returns collection') { expect(response.body).to eq collection.to_json }

    it('returns HTTP Status Code 200') { expect(response).to have_http_status 200 }
  end
end
