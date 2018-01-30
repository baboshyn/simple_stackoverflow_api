require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it('authenticate user') { is_expected.to be_kind_of(ActionController::HttpAuthentication::Basic::ControllerMethods) }

  describe 'POST #create' do
    let(:user) { instance_double(User, id: 1, email: 'test@test.com') }

    context "user didn't pass authentication" do
      context 'user sent invalid email' do
        before { expect(subject).to receive(:authenticate).and_raise ActiveRecord::RecordNotFound }

        before { process :create, method: :post, format: :json }

        it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
      end

      context 'user sent invalid password' do
        before { allow(User).to receive(:find_by!).with(email: 'test@test.com').and_return(user) }

        before { allow(user).to receive(:authenticate).with('invalid_password').and_return(false) }

        before { process :create, method: :post, format: :json }

        it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }
      end
    end

    context 'user passed authentication' do
      before { sign_in user }

      context "user didn't pass authorization" do
        before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { process :create, method: :post, format: :json }

        it('returns HTTP Status Code 403') { expect(response).to have_http_status 403 }
      end

      context 'user passed authorization' do
        let(:token) { double }

        before { expect(subject).to receive(:authorize).and_return true }

        before { allow(SimpleStackoverflowToken).to receive(:encode).with({ user_id: user.id }).and_return(token) }

        before { process :create, method: :post, format: :json }

        it('returns created token') { expect(response.body).to eq ({ token: token }).to_json }

        it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
      end
    end
  end
end
