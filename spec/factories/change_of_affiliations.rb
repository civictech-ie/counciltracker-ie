FactoryBot.define do
  factory :change_of_affiliation do
    councillor
    association :outgoing_party, factory: :party
    association :incoming_party, factory: :party
    occurred_on { Faker::Date.backward(365) }
  end
end