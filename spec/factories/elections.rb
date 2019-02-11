FactoryBot.define do
  factory :election do
    parameters { [{ party_name: "Sinn Féin", councillor_name: "Gaye Fagan", local_electoral_area_name: "North Inner City"}] }
  end
end