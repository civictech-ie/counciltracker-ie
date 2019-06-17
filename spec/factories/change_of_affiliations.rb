FactoryBot.define do
  factory :change_of_affiliation do
    association :councillor, factory: [:councillor, :active]
    association :outgoing_party, factory: :party
    association :incoming_party, factory: :party
    occurred_on { Faker::Date.unique.backward(365) }
  end
end