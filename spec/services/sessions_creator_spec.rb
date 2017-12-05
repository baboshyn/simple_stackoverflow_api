require 'rails_helper'
RSpec.describe SessionsCreator do
  it { is_expected.to be_a ActiveModel::Validations }

  let(:sessions_creator) { SessionsCreator.new email: 'test@test.com', password: '12345678' }

  let(:user) { instance_double User }

  subject { sessions_creator }

  its(:email) { is_expected.to eq 'test@test.com' }

  its(:password) { is_expected.to eq '12345678' }



  describe '#user' do
    before { expect(User).to receive(:find_by).with(email: 'test@test.com') }

    it { expect { subject.send :user }.to_not raise_error }
  end

  context 'validations' do
    subject { sessions_creator.errors }

    context do
      before { expect(sessions_creator).to receive(:user) }

      before { sessions_creator.valid? }

      its([:email]) { is_expected.to eq ['not found'] }
    end

    context do
      before { allow(sessions_creator).to receive(:user).twice.and_return(user) }

      before { allow(user).to receive(:authenticate).with('12345678').and_return(false) }

      before { sessions_creator.valid? }

      its([:password]) { is_expected.to eq ['is invalid'] }
    end

    context do
      before { allow(sessions_creator).to receive(:user).twice.and_return(user) }

      before { allow(user).to receive(:authenticate).with('12345678').and_return(true) }

      before { sessions_creator.valid? }

      it { expect { subject }.to_not raise_error }
    end
  end


  describe '#create' do
    context do
      let(:errors) { sessions_creator.errors }

      before { allow(subject).to receive(:valid?).and_return(false) }

      its(:create) { is_expected.to eq errors }
    end

    context do
      let(:sessions) { instance_double Session }

      before { allow(subject).to receive(:valid?).and_return(true) }

      before  do
        allow(subject).to receive(:user) do
          double.tap do |user|
            allow(user).to receive(:sessions) do
              double.tap { |users_session| allow(users_session).to receive(:create!).and_return(sessions) }
            end
          end
        end
      end

      its(:create) { is_expected.to eq sessions }
    end
  end
end
