require 'rails_helper'
RSpec.describe Token do
  it { is_expected.to be_a ActiveModel::Validations }

  let(:token) { Token.new email: 'test@test.com', password: '12345678' }

  let(:user) { instance_double User }

  subject { token }

  its(:email) { is_expected.to eq 'test@test.com' }

  its(:password) { is_expected.to eq '12345678' }



  describe '#user' do
    before { expect(User).to receive(:find_by).with(email: 'test@test.com') }

    it { expect { subject.send :user }.to_not raise_error }
  end

  context 'validations' do
    subject { token.errors }

    context do
      before { expect(token).to receive(:user) }

      before { token.valid? }

      its([:email]) { is_expected.to eq ['not found'] }
    end

    context do
      before { allow(token).to receive(:user).twice.and_return(user) }

      before { allow(user).to receive(:authenticate).with('12345678').and_return(false) }

      before { token.valid? }

      its([:password]) { is_expected.to eq ['is invalid'] }
    end

    context do
      before { allow(token).to receive(:user).twice.and_return(user) }

      before { allow(user).to receive(:authenticate).with('12345678').and_return(true) }

      before { token.valid? }

      it { expect { subject }.to_not raise_error }
    end
  end


  describe '#save' do
    context do
      let(:errors) { token.errors }

      before { allow(subject).to receive(:valid?).and_return(false) }

      its(:save) { is_expected.to eq errors }
    end

    context do
      let(:user) { instance_double User, id: 1 }

      before { allow(token).to receive(:user).and_return(user) }

      before { allow(subject).to receive(:valid?).and_return(true) }

      before { expect(JsonWebToken).to receive(:issue).with({ user: user.id }).and_return(:token_value) }

      its(:save) { is_expected.to eq :token_value }
    end
  end
end
