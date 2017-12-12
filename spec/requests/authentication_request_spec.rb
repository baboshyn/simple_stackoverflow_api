require 'rails_helper'

RSpec.describe 'AuthenticationRequest', type: :request do

  let(:user) { FactoryBot.create(:user) }

  let(:serialized_user) { UserSerializer.new(user) }

  let(:token) { SimpleStackoverflawToken.encode({ user_id: user.id }) }

  let(:headers) { { 'Authorization' => "Bearer #{token}", 'Content-type' => 'application/json' } }

  before { get '/profile', params: {} , headers: headers }

  context 'with valid params' do
    it { expect(response.body).to eq (serialized_user).to_json }
  end

  context 'with invalid params' do
    let(:token) { 'another_token' }

    it { expect(response).to have_http_status 401 }

    it { expect(response.body).to eq "HTTP Token: Access denied.\n" }
  end
end
