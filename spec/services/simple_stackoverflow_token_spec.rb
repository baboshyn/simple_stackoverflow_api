require 'rails_helper'
RSpec.describe SimpleStackoverflowToken do

  let(:user) { FactoryBot.create( :user) }

  let(:exp) { 1.day.from_now.to_i }

  let(:payload) { { user_id: user.id, exp: exp } }

  let(:auth_secret) { Rails.application.secrets.secret_key_base }

  let(:token) { described_class.encode(payload) }


  describe '#decode' do
    context 'token is expired' do
      let(:exp) { 1.day.ago }

      it { expect(described_class.decode(token)).to eq false }
    end

    context 'token is invalid' do
      let(:token) { 'invalid_token' }

      it { expect(described_class.decode(token)).to eq false }
    end

    context 'token is valid' do
      it { expect(described_class.decode(token).first).to eq payload.stringify_keys }
    end
  end
end
