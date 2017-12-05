require 'rails_helper'
RSpec.describe UsersCreator do
  let(:params) { attributes_for(:user) }
  let(:users_creator) { UsersCreator.new params }
  let(:user) { instance_double(User, as_json: params, **params) }

  subject { users_creator }

  describe '#create' do
    before { allow(User).to receive(:new).with(params).and_return(user) }

    before { allow(user).to receive(:save!).and_return(user) }

    its(:create) { is_expected.to eq user }
  end
end
