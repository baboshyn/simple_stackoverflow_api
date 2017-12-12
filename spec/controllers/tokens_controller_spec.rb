require 'rails_helper'
RSpec.describe TokensController, type: :controller do

  describe '#create' do
    let(:params) { { token: { login: 'test', password: 'test' } } }
    let(:resource_params) { params[:token] }
    let(:user) { instance_double User, id: '1' }

    context 'user was not found by login' do
      before { expect(User).to receive(:find_by).with(login: resource_params[:login]) }

      before { process :create, method: :post, params: params, format: :json }

      it { expect(response.body).to eq ({ error: 'Invalid login or password' }).to_json }

      it { expect(response).to have_http_status 404 }
    end

    context 'user was foun by login' do
      before { allow(User).to receive(:find_by).with(login: resource_params[:login]).and_return(user) }

      context 'password is invalid' do
        before { allow(user).to receive(:authenticate).with(resource_params[:password]).and_return(false) }

        before { process :create, method: :post, params: params, format: :json }

        it { expect(response.body).to eq ({ error: 'Invalid login or password' }).to_json }

        it { expect(response).to have_http_status 404 }
      end

      context 'password is valid' do
        let(:token) { double }

        before { allow(User).to receive(:find_by).with(login: resource_params[:login]).and_return(user) }

        before { allow(user).to receive(:authenticate).with(resource_params[:password]).and_return(true) }

        before { allow(SimpleStackoverflawToken).to receive(:encode).with({user: user.id}).and_return(token) }

        before { process :create, method: :post, params: params, format: :json }

        it { expect(response.body).to eq ({ token: token }).to_json }

        it { expect(response).to have_http_status 201 }
      end
    end
  end
end
