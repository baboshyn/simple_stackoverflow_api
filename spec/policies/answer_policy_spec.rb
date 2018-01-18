require 'rails_helper'

describe AnswerPolicy do
  subject { described_class }

  let(:author) { User.new(id: 1) }

  let(:another_user) { User.new(id: 2) }

  let(:answer) { Answer.new(user_id: 1) }

  permissions :update?, :destroy? do
    it "refuses access if user is not author for answer" do
      expect(subject).not_to permit(another_user, answer)
    end

    it "grants access if user is an author for answer" do
      expect(subject).to permit(author, answer)
    end
  end
end
