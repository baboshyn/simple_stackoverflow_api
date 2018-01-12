require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:resource_params) { attributes_for(:user) }

  let(:user) { instance_double(User, id: 1, as_json: resource_params, **resource_params) }

  describe 'POST #create' do
    let(:creator) { UserCreator.new(resource_params) }

    context 'new user was created' do
      before { allow(UserCreator).to receive(:new).and_return(creator) }

      before { expect(creator).to receive(:on).exactly(3).times.and_call_original }

      before do
        expect(creator).to receive(:call) do
          creator.send(:broadcast, :succeeded, user)
        end
      end

      before { expect(ConfirmationHandler).to receive(:publish_confirmation).with(user) }

      before { process :create, method: :post, params: { user: resource_params }, format: :json }

      it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
    end

    context 'new user was not created' do
      let(:errors) { instance_double(ActiveModel::Errors) }

      before { allow(UserCreator).to receive(:new).and_return(creator) }

      before { expect(creator).to receive(:on).exactly(3).times.and_call_original }

      before do
        expect(creator).to receive(:call) do
          creator.send(:broadcast, :failed, errors)
        end
      end

      before { process :create, method: :post, params: { user: resource_params }, format: :json }

      it('returns errors') { expect(response.body).to eq errors.to_json }

      it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
    end

    context 'bad request was sent' do
      before { process :create, method: :post, params: { ' ': resource_params }, format: :json }

      it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
    end
  end

  describe 'GET #confirm' do
    let(:params) { { id: 'confirmation_token' } }

    context 'valid confirmation token was send in request' do

      before { allow(ConfirmationParser).to receive(:parse).with(params[:id]).and_return(1) }

      before do
        allow(User).to receive(:find).with(1) do
          user.tap { |user| allow(user).to receive(:update).with(state: 1) }
        end
      end

      before { process :confirm, method: :get, params: params, format: :json }

      it('returns confirmed user') { expect(response.body).to eq user.to_json }

      it('returns HTTP Status Code 200') { expect(response).to have_http_status 200 }
    end

    context 'invalid confirmation token was send in request' do
      before { allow(ConfirmationParser).to receive(:parse).with(params[:id]).and_return(nil) }

      before { process :confirm, method: :get, params: params, format: :json }

      it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
    end
  end
end



