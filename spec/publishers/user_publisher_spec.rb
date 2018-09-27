require 'rails_helper'
RSpec.describe UserPublisher do
  let(:message) { double }

  describe '#publish' do
    before do
      expect(PubSub).to receive(:client) do
        double.tap { |pubsub| expect(pubsub).to receive(:publish).with(UserPublisher::CHANNEL, message) }
      end
    end

    it('publishes data') { expect { described_class.publish(message) }.to_not raise_error }
  end
end
