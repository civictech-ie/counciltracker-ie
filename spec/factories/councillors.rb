FactoryBot.define do
  factory :councillor do
    full_name { Faker::Name.name }

    trait :active do
      after :create do |councillor|
        create :seat, :active, councillor: councillor
      end
    end
  end
end
