require 'rails_helper'
RSpec.describe SimpleStackoverflowToken do

  let(:user) { FactoryBot.create( :user) }

  let(:exp) { 1.day.from_now.to_i }

  let(:payload) { { user_id: user.id , exp: exp } }

  let(:auth_secret) { Rails.application.secrets.secret_key_base }

  let(:token) { JWT.encode(payload, auth_secret) }


  describe '#decode' do
    context 'token is expired' do
      before { expect(JWT).to receive(:decode).with(token, auth_secret).and_raise(JWT::ExpiredSignature) }

      it { expect(described_class.decode(token)).to eq false }
    end

    context 'token is invalid' do
      before { expect(JWT).to receive(:decode).with(token, auth_secret).and_raise(JWT::DecodeError) }

      it { expect(described_class.decode(token)).to eq false }
    end

    context 'token is valid' do
      before { expect(JWT).to receive(:decode).with(token, auth_secret) }

      it { expect { described_class.decode(token) }.to_not raise_error }
    end
  end


  describe '#encode' do
    before { expect(JWT).to receive(:encode).with(payload, auth_secret) }

    it { expect { described_class.encode(payload) }.to_not raise_error }
  end
end
