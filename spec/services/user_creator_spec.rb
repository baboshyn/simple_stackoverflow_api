require 'rails_helper'
RSpec.describe UserCreator do
  subject { UserCreator.new params }

  describe '#create' do
    context 'valid params were passed' do
      let(:user) { instance_double(User, as_json: params, **params) }

      let(:params) { attributes_for(:user) }

      before { allow(User).to receive(:create!).with(params).and_return(user) }

      it('returns created user') { expect(subject.create).to eq user }
    end

    context 'invalid params were passed' do
      let(:user) { User.new }

      let(:params) { {} }

      before { allow(User).to receive(:create!).with(params).and_raise(ActiveRecord::RecordInvalid.new(user)) }

      it('returns errors') { expect(subject.create).to eq user }
    end
  end
end
