require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#authenticate' do
    let(:payload) { double }
    let(:current_user) { instance_double User }

    before { allow(subject).to receive(:authenticate_or_request_with_http_token).and_yield('token') }

    before { allow(SimpleStackoverflawToken).to receive(:decode).with('token').and_return(payload) }

    before { expect(payload).to receive(:[]).with('user_id').and_return(1) }

    before { allow(User).to receive(:find).with(1).and_return(current_user) }

    it { expect { subject.send :authenticate }.to_not raise_error }
  end
end
