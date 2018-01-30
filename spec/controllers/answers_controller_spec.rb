require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:attrs) { attributes_for(:answer) }

  let(:answer) { instance_double(Answer, id: 1, as_json: attrs, **attrs) }

  let(:user) { instance_double User }

  let(:question) { instance_double Question }

  let(:resource_params) { attributes_for(:answer) }

  let(:answer_id) { '1' }

  before { allow(Answer).to receive(:find).with(answer_id).and_return(answer) }

  describe 'POST #create' do
    context 'user authenticated' do
      before { sign_in user }

      context 'question was found' do
        before { allow(Question).to receive(:find).with(resource_params[:question_id]).and_return(question) }

        context 'user is valid' do
          before { allow(subject).to receive(:authorize).and_return(true) }

          let(:creator) { AnswerCreator.new(resource_params, question) }

          context 'new answer was created' do
            before { allow(AnswerCreator).to receive(:new).and_return(creator) }

            before { expect(creator).to receive(:on).twice.and_call_original }

            before do
              expect(creator).to receive(:call) do
                creator.send(:broadcast, :succeeded, answer)
              end
            end

            before { process :create, method: :post, params: { answer: resource_params }, format: :json }

            it('returns created answer') { expect(response.body).to eq answer.to_json }

            it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
          end

          context 'new answer was not created' do
            let(:errors) { instance_double(ActiveModel::Errors) }

            before { allow(AnswerCreator).to receive(:new).and_return(creator) }

            before { expect(creator).to receive(:on).twice.and_call_original }

            before do
              expect(creator).to receive(:call) do
                creator.send(:broadcast, :failed, errors)
              end
            end

            before { process :create, method: :post, params: { answer: resource_params }, format: :json }

            it('returns errors') { expect(response.body).to eq errors.to_json }

            it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
          end

          context 'bad request was sent' do
            before { process :create, method: :post, params: { ' ': resource_params }, format: :json }

            it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
          end
        end

        context 'user is not valid' do
          before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

          before { process :create, method: :post, params: { answer: resource_params }, format: :json }

          it('returns HTTP Status Code 403') { expect(response).to have_http_status 403 }
        end
      end

      context 'question was not found' do
        let(:resource_params) { { question_id: '0', body: 'body' } }

        before { expect(Question).to receive(:find).with('0').and_raise ActiveRecord::RecordNotFound }

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
      let(:params) { { question_id: '1', answer: resource_params } }

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
      before { expect(Question).to receive(:find).with('0').and_raise ActiveRecord::RecordNotFound }

      before { process :index, method: :get, params: { question_id: 0, answer: resource_params, format: :json } }

      it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
    end
  end

  describe 'PATCH #update' do
    context 'user authenticated' do
      before { sign_in user }

      context 'answer was found' do
        context 'user passed authorization' do
          before { allow(subject).to receive(:authorize).and_return true }

          let(:updater) { AnswerUpdater.new(resource_params, answer) }

          context 'answer was updated' do
            before { allow(AnswerUpdater).to receive(:new).and_return(updater) }

            before { expect(updater).to receive(:on).twice.and_call_original }

            before do
              expect(updater).to receive(:call) do
                updater.send(:broadcast, :succeeded, answer)
              end
            end

            before { process :update, method: :patch, params: { id: answer_id, answer: resource_params }, format: :json }

            it('returns updated answer') { expect(response.body).to eq answer.to_json }

            it('returns HTTP Status Code 200') { expect(response).to have_http_status 200 }
          end

          context 'invalid attributes were sent' do
            let(:errors) { instance_double(ActiveModel::Errors) }

            before { allow(AnswerUpdater).to receive(:new).and_return(updater) }

            before { expect(updater).to receive(:on).twice.and_call_original }

            before do
              expect(updater).to receive(:call) do
                updater.send(:broadcast, :failed, errors)
              end
            end

            before { process :update, method: :patch, params: { id: answer_id, answer: resource_params }, format: :json }

            it('returns errors') { expect(response.body).to eq errors.to_json }

            it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
          end

          context 'bad request was sent' do
            before { process :update, method: :patch, params: {id: answer_id, ' ': resource_params }, format: :json }

            it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
          end
        end
      end

      context 'user did not pass authorization' do
        before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { process :update, method: :patch, params: { id: answer_id, answer: resource_params }, format: :json }

        it('returns HTTP Status Code 403') { expect(response).to have_http_status 403 }
      end

      context 'answer was not found' do
        before { expect(Answer).to receive(:find).with('0').and_raise ActiveRecord::RecordNotFound }

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
        context 'user passed authorization' do
          before { allow(subject).to receive(:authorize).and_return true }

          before do
            expect(AnswerDestroyer).to receive(:new).with(answer) do
              double.tap { |answer_destroyer| expect(answer_destroyer).to receive(:destroy) }
            end
          end

          before { process :destroy, method: :delete, params: { id: answer_id }, format: :json }

          it('returns HTTP Status Code 204') { expect(response).to have_http_status 204 }
        end
      end

      context 'user did not pass authorization' do
        before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { process :destroy, method: :delete, params: { id: answer_id }, format: :json }

        it('returns HTTP Status Code 403') { expect(response).to have_http_status 403 }
      end

      context 'answer was not found' do
        before { expect(Answer).to receive(:find).with('0').and_raise ActiveRecord::RecordNotFound }

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
