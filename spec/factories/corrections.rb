FactoryBot.define do
  factory :correction do
    body { "Everything is broken" }
    name { Faker::Name.name }
    email_address { Faker::Internet.email }
  end
end
