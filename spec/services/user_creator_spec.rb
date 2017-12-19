require 'rails_helper'
RSpec.describe UserCreator do
  let(:params) { attributes_for(:user) }

  let(:user) { instance_double(User, as_json: params, **params) }

  subject { UserCreator.new params }

  describe '#create' do
    before { expect(User).to receive(:create!).with(params).and_return(user) }

    its(:create) { is_expected.to eq user }
  end
end
