require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe '#current_user' do
    let(:auth_header) { double }
    let(:token) { double }
    let(:payload) { double }
    let(:user) { instance_double User }

    before do
      allow(request).to receive(:headers) do
        double.tap { |headers| allow(headers).to receive(:[]).with('Authorization').and_return(auth_header) }
      end
    end

    before do
      allow(auth_header).to receive(:split).with(' ') do
        double.tap { |auth_headers_data| allow(auth_headers_data).to receive(:last).and_return(token) }
      end
    end

    before do
      allow(JsonWebToken).to receive(:decode).with(token) do
        double.tap { |token_data| allow(token_data).to receive(:first).and_return(payload) }
      end
    end

    before { allow(payload).to receive(:[]).with('user').and_return('1') }

    before { allow(User).to receive(:find_by).with(id: '1').and_return(user) }

    its(:current_user) { is_expected.to eq user }
  end


  describe '#authenticate' do
    let(:current_user) { instance_double User }

    before { expect(subject).to receive(:current_user).and_return(current_user) }

    it { expect { subject.send :authenticate }.to_not raise_error }
  end
end
