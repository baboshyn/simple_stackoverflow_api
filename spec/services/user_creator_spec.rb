require 'rails_helper'

RSpec.describe UserCreator do
  it { is_expected.to be_a ServicesHandler }

  let(:user) { instance_double(User, id: 1, as_json: params, **params) }

  let(:params) { attributes_for(:user) }

  let(:token) { double }

  let(:message) { double }

  let(:errors) { instance_double(ActiveModel::Errors) }

  subject { UserCreator.new params }

  describe '#call' do
    before { allow(User).to receive(:new).with(params).and_return(user) }

    before do
      allow(user).to receive(:email) do
        double.tap { |user_email| allow(user_email).to receive(:downcase!) }
      end
    end

    before { expect(user).to receive(:save).and_return(true) }

    before do
      allow(SimpleStackoverflowToken).to receive(:encode).with(user_id: user.id).and_return(token)
    end

    before do
      allow(user.as_json).to receive(:merge).with(notification: 'registration', token: token).and_return(message)
    end

    before { expect(UserPublisher).to receive(:publish).with(message.to_json) }

    context 'valid params were passed' do
      before { be_broadcasted_succeeded user }

      it('broadcasts created user and publishes confirmation data') { expect { subject.call }.to_not raise_error }
    end

    context 'invalid params were passed' do
      before { allow(user).to receive(:errors).and_return(errors) }

      before { be_broadcasted_failed(user, errors) }

      it('broadcasts user.errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
