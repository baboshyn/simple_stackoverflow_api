require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:attrs) { attributes_for(:answer) }

  let(:answer) { instance_double(Answer, id: 1, as_json: attrs, **attrs) }

  let(:user) { instance_double User }

  let(:question) { instance_double Question }

  let(:resource_params) { attributes_for(:answer) }

  let(:answer_id) { "1" }

  before { allow(Answer).to receive(:find).with(answer_id).and_return(answer) }

  describe 'POST #create' do
    context 'user authenticated' do
      before { sign_in user }

      context 'question was found' do
        before { allow(Question).to receive(:find).with(resource_params[:question_id]).and_return(question) }

        before do
          allow(AnswerCreator).to receive(:new).with(resource_params, question) do
            double.tap { |answer_creator| allow(answer_creator).to receive(:create).and_return(answer) }
          end
        end

        context 'parameters for answer passed validation' do
          before { allow(answer).to receive(:valid?).and_return(true) }

          before { process :create, method: :post, params: { answer: resource_params }, format: :json }

          it('returns created answer') { expect(response.body).to eq answer.to_json }

          it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
        end

        context 'parameters for answer did not pass validation' do
          let(:errors) { instance_double(ActiveModel::Errors) }

          before { allow(answer).to receive(:valid?).and_return(false) }

          before { allow(answer).to receive(:errors).and_return(errors) }

          before { process :create, method: :post, params: { answer: resource_params }, format: :json }

          it('returns errors') { expect(response.body).to eq errors.to_json }

          it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
        end

        context 'bad request was sent' do
          before { process :create, method: :post, params: { " ": resource_params }, format: :json }

          it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
        end
      end

      context 'question was not found' do
        let(:resource_params) { { question_id: "0", body: "body" } }

        before { allow(Question).to receive(:find).with("0").and_raise ActiveRecord::RecordNotFound }

        before { process :create, method: :post, params: { answer: resource_params, format: :json } }

        it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
      end
    end

    context 'user not authenticated' do
      before { process :create, method: :post, params: { answer: resource_params, format: :json } }

      it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }
    end
  end

  describe 'GET #index' do
    context 'question was found' do
      let(:params) { { question_id: "1", answer: resource_params } }

      let(:collection) { double }

      before { allow(subject).to receive(:params).and_return(params) }

      before { allow(Question).to receive(:find).with(params[:question_id]).and_return(question) }

      before do
        allow(AnswerSearcher).to receive(:new).with(params, question) do
          double.tap { |answer_searcher| allow(answer_searcher).to receive(:search).and_return(collection) }
        end
      end

      before { process :index, method: :get, params: params, format: :json }

      it('returns collection') { expect(response.body).to eq collection.to_json }

      it('returns HTTP Status Code 200') { expect(response).to have_http_status 200 }
    end

    context 'question was not found' do
      before { allow(Question).to receive(:find).with("0").and_raise ActiveRecord::RecordNotFound }

      before { process :index, method: :get, params: { question_id: 0, answer: resource_params, format: :json } }

      it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
    end
  end

  describe 'PATCH #update' do
    context 'user authenticated' do
      before { sign_in user }

      context 'answer was found' do
        before do
          allow(AnswerUpdater).to receive(:new).with(answer, resource_params) do
            double.tap { |answer_updater| allow(answer_updater).to receive(:update).and_return(answer) }
          end
        end

        context 'parameters for answer passed validation'do
          before { allow(answer).to receive(:valid?).and_return(true) }

          before { process :update, method: :patch, params: { id: answer_id, answer: resource_params }, format: :json }

          it('returns updated answer') { expect(response.body).to eq answer.to_json }

          it('returns HTTP Status Code 200') { expect(response).to have_http_status 200 }
        end

        context 'parameters for answer did not pass validation'do
          let(:errors) { instance_double(ActiveModel::Errors) }

          before { allow(answer).to receive(:valid?).and_return(false) }

          before { allow(answer).to receive(:errors).and_return(errors) }

          before { process :update, method: :patch, params: { id: answer_id, answer: resource_params }, format: :json }

          it('returns errors') { expect(response.body).to eq errors.to_json }

          it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
        end

        context 'bad request was sent' do
          before { process :update, method: :patch, params: {id: answer_id, " ": resource_params }, format: :json }

          it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
        end
      end

      context 'answer was not found' do
        before { expect(Answer).to receive(:find).with("0").and_raise ActiveRecord::RecordNotFound }

        before { process :update, method: :patch, params: { id: 0, answer: resource_params }, format: :json }

        it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
      end
    end

    context 'user not authenticated' do
      before { process :update, method: :patch, params: { id: answer_id, answer: resource_params }, format: :json }

      it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }
    end
  end

  describe 'DELETE #destroy' do
    context 'user authenticated' do
      before { sign_in user }

      context 'answer was found' do
        before do
          expect(AnswerDestroyer).to receive(:new).with(answer) do
            double.tap { |answer_destroyer| expect(answer_destroyer).to receive(:destroy) }
          end
        end

        before { process :destroy, method: :delete, params: { id: answer_id }, format: :json }

        it('returns HTTP Status Code 204') { expect(response).to have_http_status 204 }
      end

      context 'answer was not found' do
        before { expect(Answer).to receive(:find).with("0").and_raise ActiveRecord::RecordNotFound }

        before { process :destroy, method: :delete, params: { id: 0 }, format: :json }

        it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
      end
    end

    context 'user not authenticated' do
      before { process :destroy, method: :delete, params: { id: answer_id }, format: :json }

      it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }
    end
  end
end
