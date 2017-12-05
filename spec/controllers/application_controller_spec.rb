require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe '#authenticate' do
    before { allow(subject).to receive(:authenticate_or_request_with_http_token).and_yield('token') }

    before do
      expect(User).to receive(:joins).with(:sessions) do
        double.tap do |sessions|
          expect(sessions).to receive(:find_by).with(sessions: { auth_token: 'token' })
        end
      end
    end

    it { expect { subject.send :authenticate }.to_not raise_error }
  end

  describe '#current_user' do
    let(:user) { instance_double User }

    before {sign_in user}

    its(:current_user) { is_expected.to eq user }
  end
end
