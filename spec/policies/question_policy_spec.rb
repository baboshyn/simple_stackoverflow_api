require 'rails_helper'

describe QuestionPolicy do
  subject { described_class }

  let(:question) { Question.new(user_id: 1) }

  permissions :create? do
    it "refuses access if user is not confirmed" do
      expect(subject).not_to permit(User.new)
    end

    it "grants access if user is confirmed" do
      expect(subject).to permit(User.new(state: 'confirmed'))
    end
  end

  permissions :update?, :destroy? do
    it "refuses access if user is not author for question" do
      expect(subject).not_to permit(User.new(id: 2), question)
    end

    it "grants access if user is an author for question" do
      expect(subject).to permit(User.new(id: 1), question)
    end
  end
end
