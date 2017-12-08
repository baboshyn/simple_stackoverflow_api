require 'rails_helper'
RSpec.describe JsonWebToken do

  describe 'AUTH_SECRET' do
   let(:auth_secret) {stub_const 'AUTH_SECRET', 'secret' }

    it { expect(auth_secret).to eq 'secret' }
  end

  describe '#decode' do
    let(:auth_secret) {stub_const 'AUTH_SECRET', Rails.application.secrets.secret_key_base }

    let(:token) { double }

    before { expect(JWT).to receive(:decode).with(token, auth_secret) }

    it { expect { described_class.decode(token) }.to_not raise_error }
  end


  describe '#encode' do
    let(:meta) { double }

    let(:payload) { double }

    let(:auth_secret) {stub_const 'AUTH_SECRET', Rails.application.secrets.secret_key_base }

    before { expect(described_class).to receive(:meta).and_return(meta) }

    before { expect(payload).to receive(:reverse_merge!).with(meta) }

    before { expect(JWT).to receive(:encode).with(payload, auth_secret) }

    it { expect { described_class.issue(payload) }.to_not raise_error }
  end
end
