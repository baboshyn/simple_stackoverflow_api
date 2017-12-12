require 'rails_helper'
RSpec.describe SimpleStackoverflawToken do

  describe 'AUTH_SECRET' do
   let(:auth_secret) {stub_const 'AUTH_SECRET', 'secret' }

    it { expect(auth_secret).to eq 'secret' }
  end

  describe '#decode' do
    let(:auth_secret) {stub_const 'AUTH_SECRET', Rails.application.secrets.secret_key_base }

    let(:token) { double }

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
    let(:exp) { 1.day.from_now.to_i }

    let(:payload) { { user: 1 , exp: exp } }

    let(:auth_secret) {stub_const 'AUTH_SECRET', Rails.application.secrets.secret_key_base }

    before { expect(JWT).to receive(:encode).with(payload, auth_secret) }

    it { expect { described_class.encode(payload) }.to_not raise_error }
  end
end
