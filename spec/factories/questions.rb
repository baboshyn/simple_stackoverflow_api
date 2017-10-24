FactoryGirl.define do
  factory :question do
    title { Faker::Simpsons.character }
    body { Faker::Simpsons.quote }
  end
end
