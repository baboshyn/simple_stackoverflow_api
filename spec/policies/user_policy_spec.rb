require 'rails_helper'

describe UserPolicy, type: :policy do
  subject { described_class }

  permissions :confirm? do
    it 'refuses access if user is confirmed' do
      expect(subject).not_to permit(confirmed_user)
    end

    it 'grants access if user is unconfirmed' do
      expect(subject).to permit(unconfirmed_user)
    end
  end
end
