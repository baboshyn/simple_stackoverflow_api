require 'rails_helper'

describe AnswerPolicy do
  subject { described_class }

  permissions :create? do
    it 'refuses access if user is not confirmed' do
      expect(subject).not_to permit(unconfirmed_user)
    end

    it 'grants access if user is confirmed' do
      expect(subject).to permit(confirmed_user)
    end
  end

  permissions :update?, :destroy? do
    it 'refuses access if user is not author for answer' do
      expect(subject).not_to permit(not_author, answer)
    end

    it 'refuses access if user is not confirmed' do
      expect(subject).not_to permit(unconfirmed_user, answer)
    end

    it 'grants access if user is an author for answer and confirmed' do
      expect(subject).to permit(confirmed_user, answer)
    end
  end
end
