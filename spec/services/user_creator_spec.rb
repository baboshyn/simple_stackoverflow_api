require 'rails_helper'
RSpec.describe UserCreator do
  it { is_expected.to be_a ServicesHandler }

  let(:user) { instance_double(User, as_json: params, **params) }

  let(:params) { attributes_for(:user) }

  subject { UserCreator.new params }

  describe '#call' do
    before { allow(User).to receive(:create).with(params).and_return(user) }

    context 'valid params were passed' do
      before { allow(user).to receive(:valid?).and_return(true) }

      before { expect(subject).to receive(:broadcast).with(:succeeded, user) }

      it('broadcasts created user') { expect { subject.call }.to_not raise_error }
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
