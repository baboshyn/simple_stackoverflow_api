require 'rails_helper'

describe UserPolicy do
  subject { described_class }

  let(:confirmed_user) { User.new(state: :confirmed) }

  let(:unconfirmed_user) { User.new }

  permissions :confirm? do
    it 'refuses access if user is nil' do
      expect(subject).not_to permit(nil)
    end

    it 'refuses access if user is confirmed' do
      expect(subject).not_to permit(confirmed_user)
    end

    it 'grants access if user is unconfirmed' do
      expect(subject).to permit(unconfirmed_user)
    end
  end
end
