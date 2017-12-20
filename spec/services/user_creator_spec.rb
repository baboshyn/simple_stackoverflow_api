require 'rails_helper'
RSpec.describe UserCreator do
  let(:user) { instance_double(User, as_json: params, **params) }

  let(:invalid_record) { double }

  let(:invalid) { double }

  subject { UserCreator.new params }

  describe '#create' do
    context '#valid params were passed' do
      let(:params) { attributes_for(:user) }

      before { allow(User).to receive(:create!).with(params).and_return(user) }

      its(:create) { is_expected.to eq user }
    end

    # context '#invalid params were passed' do
    #   let(:params) { { } }

    #   before { allow(User).to receive(:create!).with(params).and_raise(ActiveRecord::RecordInvalid) }


    # end
  end
end
