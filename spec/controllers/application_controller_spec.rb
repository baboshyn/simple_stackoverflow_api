require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it { is_expected.to be_kind_of(Authenticatable) }

  describe '@current_user' do
    let(:user) { instance_double User }

    before { sign_in user }

    its(:current_user) { is_expected.to eq user }
  end
end
