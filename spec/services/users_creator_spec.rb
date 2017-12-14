require 'rails_helper'
RSpec.describe UsersCreator do
  it { is_expected.to be_kind_of(Saveable) }

  let(:params) { attributes_for(:user) }
  let(:users_creator) { UsersCreator.new params }
  let(:user) { instance_double(User, as_json: params, **params) }

  subject { users_creator }

  describe '#create' do
    # before { expect(User).to receive(:new).with(params).and_return(user) }

    # before { expect(user).to receive(:save!).and_return(user) }

    # before do
    #   allow(User).to receive(:new).with(params) do
    #     double.tap { |initialized_user| allow(initialized_user).to receive(:save!).and_return(user) }
    #   end
    # end

    it { expect(subject.create).to eq user  }
  end
end

