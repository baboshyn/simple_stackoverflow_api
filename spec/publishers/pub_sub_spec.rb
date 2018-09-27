require 'rails_helper'
RSpec.describe PubSub do
  describe '#client' do
    before { expect(Redis).to receive(:current) }

    it('starts redis') { expect { described_class.client }.to_not raise_error }
  end
end
