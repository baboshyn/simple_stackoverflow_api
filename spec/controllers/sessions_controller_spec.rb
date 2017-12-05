require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { instance_double User }

  describe '#create' do
    let(:resource_params) { { session: { email: 'test@test.com', password: 'test' } } }

    before do
      allow(SessionsCreator).to receive(:new).with(permit!(email: 'test@test.com', password: 'test')) do
        double.tap { |sessions_creator| allow(sessions_creator).to receive(:create).and_return(resource) }
      end
    end

    context '#parameters for session did not passed validation'do

      let(:resource) { instance_double(ActiveModel::Errors) }

      let(:messages) { instance_double(ActiveModel::Errors) }

      before { allow(resource).to receive(:is_a?).with(ActiveModel::Errors).and_return(true) }

      before { allow(resource).to receive(:messages).and_return(messages) }

      before { process :create, method: :post, params: resource_params, format: :json }

      it { expect(response.body).to eq messages.to_json }

      it { expect(response).to have_http_status 422 }
    end

    context '#parameters for session passed validation'do
      let(:resource) { instance_double Session }

      before { process :create, method: :post, params: resource_params, format: :json }

      it { expect(response.body).to eq resource.to_json }

      it { expect(response).to have_http_status 201 }
    end
  end

  describe '#destroy' do
    before { sign_in user }

    before do
      expect(SessionsDestroyer).to receive(:new).with(user) do
        double.tap { |sessions_destroyer| expect(sessions_destroyer).to receive(:destroy) }
      end
    end

    before { process :destroy, method: :delete, format: :json }

    it { expect(response).to have_http_status 204 }
  end
end
