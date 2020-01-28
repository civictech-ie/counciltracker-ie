FactoryBot.define do
  factory :election do
    parameters { [{party_name: "Sinn Féin", councillor_name: Faker::Name.name, local_electoral_area_name: "North Inner City"}] }
    occurred_on { Faker::Date.backward(365) }
  end
end
