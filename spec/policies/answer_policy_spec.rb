require 'rails_helper'

describe AnswerPolicy do
  subject { described_class }

  let(:answer) { Answer.new(user_id: 1) }

  permissions :create? do
    it "refuses access if user is not confirmed" do
      expect(subject).not_to permit(User.new)
    end

    it "grants access if user is confirmed" do
      expect(subject).to permit(User.new(state: 'confirmed'))
    end
  end

  permissions :update?, :destroy? do
    it "refuses access if user is not author for answer" do
      expect(subject).not_to permit(User.new(id: 2), answer)
    end

    it "grants access if user is an author for answer" do
      expect(subject).to permit(User.new(id: 1), answer)
    end
  end
end
