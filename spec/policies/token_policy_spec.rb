require 'rails_helper'

describe TokenPolicy do
  subject { described_class }

  let(:confirmed_user) { User.new(state: :confirmed) }

  let(:unconfirmed_user) { User.new }

  permissions :create? do
    it 'refuses access if user is unconfirmed' do
      expect(subject).not_to permit(unconfirmed_user, :Token)
    end

    it 'grants access if user is confirmed' do
      expect(subject).to permit(confirmed_user, :Token)
    end
  end
end
