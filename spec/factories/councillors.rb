FactoryBot.define do
  factory :councillor do
    full_name { Faker::Name.name }
  end
end
