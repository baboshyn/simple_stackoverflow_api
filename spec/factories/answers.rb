FactoryGirl.define do
  factory :answer do
    body { Faker::FamilyGuy.quote }
    
    question
  end
end
