require 'rails_helper'

describe QuestionPolicy do
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
    it 'refuses access if user is not author for question' do
      expect(subject).not_to permit(not_author, question)
    end

    it 'refuses access if user is not confirmed' do
      expect(subject).not_to permit(unconfirmed_user, question)
    end

    it 'grants access if user is an author for question and confirmed' do
      expect(subject).to permit(confirmed_user, question)
    end
  end
end
