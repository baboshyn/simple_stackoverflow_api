require 'acceptance_helper'

RSpec.describe 'Authentication Basic', type: :request do

  let(:user) { create(:user, state: 1) }

  let(:token) { SimpleStackoverflowToken.encode({ user_id: user.id }) }

  let(:auth_header) { ActionController::HttpAuthentication::Basic.encode_credentials(email, password) }

  let(:headers) { { 'Authorization' => auth_header, 'Content-type' => 'application/json' } }

  let(:email) { user.email }

  let(:password) { user.password }

  before { post '/tokens', headers: headers }

  context 'user passed authentication' do
    it('returns created token') { expect(response.body).to eq ({ token: token }).to_json }

    it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
  end

  context 'user did not pass authentication' do
    context 'user was not found' do
      let(:email) { 'invalid_email' }

      it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
    end

    context 'invalid password' do
      let(:password) { 'invalid_password' }

      it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }

      it('returns "HTTP Basic: Access denied."') { expect(response.body).to eq "HTTP Basic: Access denied.\n" }

      it('returns header "WWW-Authenticate"') { expect(response.header['WWW-Authenticate']).to eq "Basic realm=\"Application\"" }
    end
  end
end
