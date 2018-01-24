require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  describe 'POST #create' do
    let(:params) { { login: { email: 'test', password: 'test' } } }

    let(:resource_params) { params[:login] }

    let(:user) { instance_double User, id: '1' }

    context 'user was not found by email' do
      before { expect(User).to receive(:find_by!).with(email: resource_params[:email].downcase).and_raise ActiveRecord::RecordNotFound }

      before { process :create, method: :post, params: params, format: :json }

      it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
    end

    context 'user was found by email' do
      before do
        allow(User).to receive(:find_by!).with(email: resource_params[:email].downcase).and_return(user)
      end

      context 'user passed confirmation' do
        before { allow(subject).to receive(:authorize).and_return(true) }

        context 'password is not valid' do
          before { allow(user).to receive(:authenticate).with(resource_params[:password]).and_return(false) }

          before { process :create, method: :post, params: params, format: :json }

          it('returns errors') { expect(response.body).to eq ({ password: ['Invalid password'] }).to_json }

          it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
        end

        context 'password is valid' do
          let(:token) { double }

          before { allow(user).to receive(:authenticate).with(resource_params[:password]).and_return(true) }

          before { allow(SimpleStackoverflowToken).to receive(:encode).with({user_id: user.id}).and_return(token) }

          before { process :create, method: :post, params: params, format: :json }

          it('returns created token') { expect(response.body).to eq ({ token: token }).to_json }

          it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
        end

        context 'bad request was sent' do
          before { process :create, method: :post, params: {' ': resource_params}, format: :json }

          it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
        end
      end

      context "user didn't pass confirmation" do
        before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { process :create, method: :post, params: params, format: :json }

        it('returns HTTP Status Code 403') { expect(response).to have_http_status 403 }
      end
    end
  end
end
