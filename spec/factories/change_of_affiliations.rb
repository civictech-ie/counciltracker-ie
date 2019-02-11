FactoryBot.define do
  factory :change_of_affiliation do
    councillor
    association :outgoing_party, factory: :party
    association :incoming_party, factory: :party
  end
end