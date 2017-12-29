require 'acceptance_helper'

RSpec.describe 'Authentication', type: :request do

  let(:user) { create(:user, attrs) }

  let(:attrs) { { login: 'test', email: 'test@test.com' } }

  let(:user_response) { { id: user.id, login: user.login, email: user.email } }

  let(:token) { SimpleStackoverflowToken.encode({ user_id: user.id }) }

  let(:headers) { { 'Authorization' => "Bearer #{token}", 'Content-type' => 'application/json' } }

  before { get '/profile', params: {} , headers: headers }

  context 'with valid params' do
    it('returns authenticated user') { expect(response.body).to eq user_response.to_json }

    it('returns HTTP Status Code 200') { expect(response).to have_http_status 200 }
  end

  context 'with invalid params' do
    let(:token) { 'another_token' }

    it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }

    it('returns "HTTP Token: Access denied."') { expect(response.body).to eq "HTTP Token: Access denied.\n" }

    it('returns header "WWW-Authenticate"') { expect(response.header['WWW-Authenticate']).to eq "Token realm=\"Application\"" }
  end
end
