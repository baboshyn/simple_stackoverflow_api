FactoryGirl.define do
  factory :session do
    auth_token { Faker::Internet.password }

    user
  end
end
