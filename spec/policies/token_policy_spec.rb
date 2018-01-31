require 'rails_helper'

describe TokenPolicy do
  subject { described_class }

  permissions :create? do
    it 'refuses access if user is unconfirmed' do
      expect(subject).not_to permit(unconfirmed_user, :token)
    end

    it 'grants access if user is confirmed' do
      expect(subject).to permit(confirmed_user, :token)
    end
  end
end
