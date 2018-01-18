require 'rails_helper'

RSpec.describe ServicesHandler do
  describe '#initialize' do
    it("demonstrates that ServicesHandler can't have instances") do
      expect { subject.new }.to raise_error NotImplementedError
    end
  end
end
