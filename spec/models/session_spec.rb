require 'rails_helper'

RSpec.describe Session, type: :model do
  it { is_expected.to be_an ApplicationRecord }

  it { is_expected.to belong_to :user  }

  it { is_expected.to validate_uniqueness_of :auth_token }


  describe '#set_token' do
    before { allow(SecureRandom).to receive(:uuid).and_return('token') }

    before { subject.send :set_token }

    its(:auth_token) { should eq 'token' }
  end
end
