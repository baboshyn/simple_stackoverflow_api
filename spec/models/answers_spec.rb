require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to be_an ApplicationRecord }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to validate_uniqueness_of :body }

  it { is_expected.to belong_to(:question) }
end
