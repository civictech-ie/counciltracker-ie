FactoryBot.define do
  factory :event do
    association :eventable, factory: :co_option
    occurred_on { Faker::Date.backward(30) }
  end
end