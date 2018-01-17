require 'rails_helper'
RSpec.describe PubSub do
  describe '#call' do
    before { expect(Redis).to receive(:current) }

    it('starts redis') { expect { described_class.call }.to_not raise_error }
  end
end
