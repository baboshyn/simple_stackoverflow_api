FactoryBot.define do
  factory :answer do
    body { Faker::FamilyGuy.quote }
    question
    user
  end
end
