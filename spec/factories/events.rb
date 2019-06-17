FactoryBot.define do
  factory :event do
    association :eventable, factory: :election
    occurred_on { Faker::Date.backward(30) }
  end
end