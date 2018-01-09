require 'rails_helper'

RSpec.describe ConfirmationHandler do
  describe '#publish_confirmation' do
    let(:user) { instance_double(User, as_json: attrs, **attrs) }

    let(:attrs) { { first_name: 'Kaci', last_name: 'Ernser', email: 'test@test.com' } }

    let(:confirmation_token) { double }

    before { allow(user).to receive(:confirmation_token).and_return(confirmation_token) }

    before do
      expect(Redis).to receive(:current) do
        double.tap{ |redis| allow(redis).to receive(:publish)
                                        .with('notificationer.email',
                                              { confirmation_token: confirmation_token,
                                                        first_name: user.first_name,
                                                         last_name: user.last_name,
                                                             email: user.email,
                                                        event_type: 'registration' }.to_json) }
      end
    end


    it { expect { described_class.publish_confirmation(user) }.to_not raise_error }
  end
end
