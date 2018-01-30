require 'rails_helper'

RSpec.describe ServicesHandler do
  describe '#initialize' do
    it('demonstrates that ServicesHandler is an abstract class') do
      expect { subject.new }.to raise_error NotImplementedError
    end
  end
end
