require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to be_an ApplicationRecord }

  it { is_expected.to validate_presence_of :name }

  it { is_expected.to validate_presence_of :email }

  it { is_expected.to_not allow_value('test').for(:email) }

  it { is_expected.to allow_value('test@test.com').for(:email) }

  it { is_expected.to have_secure_password }
end
