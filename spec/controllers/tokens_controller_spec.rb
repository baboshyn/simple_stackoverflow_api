require 'rails_helper'

RSpec.describe TokensController, type: :controller do

  describe '#create' do
    let(:resource_params) { { token: { email: 'test@test.com', password: 'test' } } }

    before do
      allow(Token).to receive(:new).with(permit!(email: 'test@test.com', password: 'test')) do
        double.tap { |token| allow(token).to receive(:save).and_return(resource) }
      end
    end

    context '#parameters for token did not passed validation'do

      let(:resource) { instance_double(ActiveModel::Errors) }

      let(:messages) { instance_double(ActiveModel::Errors) }

      before { allow(resource).to receive(:is_a?).with(ActiveModel::Errors).and_return(true) }

      before { allow(resource).to receive(:messages).and_return(messages) }

      before { process :create, method: :post, params: resource_params, format: :json }

      it { expect(response.body).to eq messages.to_json }

      it { expect(response).to have_http_status 422 }
    end

    context '#parameters for token passed validation'do
      let(:resource) { instance_double Token }

      before { process :create, method: :post, params: resource_params, format: :json }

      it { expect(response.body).to eq ({ token: resource }).to_json }

      it { expect(response).to have_http_status 201 }
    end
  end
end
