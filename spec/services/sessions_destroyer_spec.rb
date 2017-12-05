require 'rails_helper'

RSpec.describe SessionsDestroyer do
  let(:user) { instance_double User }
  let(:params) { user }
  let(:sessions_destroyer) { SessionsDestroyer.new params }

  subject { sessions_destroyer }

  describe '#destroy' do
    before do
      expect(user).to receive(:sessions) do
        double.tap { |users_sessions| expect(users_sessions).to receive(:destroy_all) }
      end
    end
    it { expect { subject.send :destroy }.to_not raise_error }
  end
end
