require 'rails_helper'

describe UserPolicy do
  subject { described_class }

  let(:user) { User.new(id: 1) }

  let(:confirmed_user) { User.new(id: 1, state: :confirmed) }

  let(:unconfirmed_user) { User.new(id: 1, state: :unconfirmed) }

  permissions :confirm? do
    it "denies access if user is nil" do
      expect(subject).not_to permit(user, nil)
    end

    it "denies access if user is confirmed" do
      expect(subject).not_to permit(user, confirmed_user)
    end

    it "grants access if user is unconfirmed" do
      expect(subject).to permit(user, unconfirmed_user)
    end
  end
end
