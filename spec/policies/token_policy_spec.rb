require 'rails_helper'

describe TokenPolicy do
  subject { described_class }

  permissions :create? do
    it 'refuses access if user is unconfirmed' do
      expect(subject).not_to permit(User.new, :token)
    end

    it 'grants access if user is confirmed' do
      expect(subject).to permit(User.new(state: :confirmed), :token)
    end
  end
end
