require 'rails_helper'
RSpec.describe UserCreator do
  it { is_expected.to be_a ServicesHandler }

  let(:user) { instance_double(User, id: 1, as_json: params, **params) }

  let(:params) { attributes_for(:user) }

  let(:token) { double }

  let(:message) { double }

  subject { UserCreator.new params }

  describe '#call' do
    before { allow(User).to receive(:new).with(params).and_return(user) }

    before do
      allow(user).to receive(:email) do
        double.tap { |user_email| allow(user_email).to receive(:downcase!) }
      end
    end

    before { expect(user).to receive(:save) }

    context 'valid params were passed' do
      before { allow(user).to receive(:valid?).and_return(true) }

      before do
        allow(SimpleStackoverflowToken).to receive(:encode).with(user_id: user.id).and_return(token)
      end

      before do
        allow(ActiveModelSerializers::SerializableResource).to receive(:new).with(user) do
          double.tap do |user_serialized|
            allow(user_serialized).to receive(:as_json) do
              double.tap do |attributes|
                allow(attributes).to receive(:merge).with(notification: 'registration', token: token).and_return(message)
              end
            end
          end
        end
      end

      before { expect(UserPublisher).to receive(:publish).with(message.to_json) }

      before { expect(subject).to receive(:broadcast).with(:succeeded, user) }

      it('broadcasts created user and publishes confirmation data') { expect { subject.call }.to_not raise_error }
    end

    context 'invalid params were passed' do
      let(:errors) { instance_double(ActiveModel::Errors) }

      before { allow(user).to receive(:errors).and_return(errors) }

      before { allow(user).to receive(:valid?).and_return(false) }

      before { expect(subject).to receive(:broadcast).with(:failed, errors) }

      it('broadcasts user.errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
