require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:attrs) { attributes_for(:user) }

  let(:user) { instance_double(User, id: 1, as_json: attrs, **attrs) }

  describe 'POST #create' do
    let(:resource_params) { attributes_for(:user) }

    before do
      allow(UserCreator).to receive(:new).with(resource_params) do
        double.tap { |user_creator| allow(user_creator).to receive(:create).and_return(user) }
      end
    end

    context 'parameters for user passed validation' do
      before { allow(user).to receive(:valid?).and_return(true) }

      before { process :create, method: :post, params: { user: resource_params }, format: :json }

      it('returns created user') { expect(response.body).to eq user.to_json }

      it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
    end

    context 'parameters for user did not pass validation' do
      let(:errors) { instance_double(ActiveModel::Errors) }

      before { allow(user).to receive(:valid?).and_return(false) }

      before { allow(user).to receive(:errors).and_return(errors) }

      before { process :create, method: :post, params: { user: resource_params }, format: :json }

      it('returns errors') { expect(response.body).to eq errors.to_json }

      it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
    end

    context 'bad request was sent' do
      before { process :create, method: :post, params: { " ": resource_params }, format: :json }

      it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
    end
  end
end
