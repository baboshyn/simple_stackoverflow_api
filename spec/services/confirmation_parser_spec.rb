require 'rails_helper'

RSpec.describe ConfirmationParser do
  describe '#parse' do
    context 'valid token was passed' do
      let(:data) { { :user_id => '1' } }

      let(:confirmation_token) { double }

      before { allow(SimpleStackoverflowToken).to receive(:decode).with(confirmation_token).and_return(data) }

      it('returns parsed user_id value') { expect(described_class.parse(confirmation_token)).to eq data['user_id'] }
    end

    context 'invalid token was passed' do
      let(:invalid_token) { 'invalid_token' }

      it('returns nil') { expect(described_class.parse(invalid_token)).to eq nil }
    end
  end
end
