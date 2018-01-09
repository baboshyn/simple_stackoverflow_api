require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to be_an ApplicationRecord }

  it { is_expected.to validate_presence_of :first_name }

  it { is_expected.to validate_presence_of :last_name }

  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it { is_expected.to_not allow_value('test').for(:email) }

  it { is_expected.to allow_value('test@test.com').for(:email) }

  it { is_expected.to have_secure_password }

  describe '#confirmation_token' do
    let(:subject) { FactoryBot.build_stubbed(:user) }

    let(:token) { double }

    before { allow(SimpleStackoverflowToken).to receive(:encode).with({ user_id: subject.id }).and_return(token) }

    it('creates user\'s confirmation_token') { expect(subject.send :confirmation_token).to eq token }
  end
end
