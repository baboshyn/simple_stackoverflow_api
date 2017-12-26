require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:user) { instance_double User }

  describe '#show' do
    context 'user passed authentication' do
      before { sign_in user }

      before { process :show, method: :get, format: :json }

      it('returns HTTP Status Code 200') { expect(response).to have_http_status 200 }

      it('returns profile') { expect(response.body).to eq user.to_json }
    end

    context 'user did not pass authentication' do
      before { process :show, method: :get, format: :json }

      it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }
    end
  end
end
