require 'rails_helper'

describe QuestionPolicy do
  subject { described_class }

  let(:author) { User.new(id: 1) }

  let(:another_user) { User.new(id: 2) }

  let(:question) { Question.new(user_id: 1) }

  permissions :update?, :destroy? do
    it "denies access if user is not author for question" do
      expect(subject).not_to permit(another_user, question)
    end

    it "grants access if user is an author for question" do
      expect(subject).to permit(author, question)
    end
  end
end
