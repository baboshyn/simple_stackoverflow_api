require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it { is_expected.to be_kind_of(Authenticatable) }

  it { is_expected.to be_an ApplicationController }

  let(:attrs) { attributes_for(:user) }

  let(:user) { instance_double(User, id: 1, as_json: attrs, **attrs) }

  describe '#create' do
    let(:resource_params) { attributes_for(:user) }

    before do
      allow(UsersCreator).to receive(:new).with(resource_params) do
        double.tap { |users_creator| allow(users_creator).to receive(:create).and_return(user) }
      end
    end

    context '#parameters for user passed validation'do
      before { allow(user).to receive(:valid?).and_return(true) }

      before { process :create, method: :post, params: { user: resource_params }, format: :json }

      it { expect(response.body).to eq user.to_json }

      it { expect(response).to have_http_status 201 }
    end

    context '#parameters for user did not pass validation'do
      let(:errors) { instance_double(ActiveModel::Errors) }

      before { allow(user).to receive(:valid?).and_return(false) }

      before { allow(user).to receive(:errors).and_return(errors) }

      before { process :create, method: :post, params: { user: resource_params }, format: :json }

      it { expect(response.body).to eq errors.to_json }

      it { expect(response).to have_http_status 422 }
    end
  end
end
