require 'rails_helper'

RSpec.describe UserSerializer do
  subject { UserSerializer.new create(:user) }

  let(:attributes) { subject.attributes.keys }

  it('returns necessary attributes for User') { expect(attributes).to eq %i[id first_name last_name email] }
end
