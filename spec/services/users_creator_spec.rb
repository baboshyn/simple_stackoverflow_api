require 'rails_helper'
RSpec.describe UsersCreator do
  it { is_expected.to be_kind_of(Saveable) }

  let(:params) { attributes_for(:user) }
  let(:user) { instance_double(User, as_json: params, **params) }

  subject { UsersCreator.new params }

  describe '#create' do
    before do
      expect(User).to receive(:new).with(params) do
        user.tap { |initialized_user| expect(initialized_user).to receive(:save!) }
      end
    end

    its(:create) { is_expected.to eq user }
  end
end
