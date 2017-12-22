require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:user) { instance_double User }

  before { sign_in user }

  describe '#show' do
    before { process :show, method: :get, format: :json }

    it { expect(response).to have_http_status 200 }

    it { expect(response.body).to eq user.to_json }
  end
end
