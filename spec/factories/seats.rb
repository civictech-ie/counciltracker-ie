FactoryBot.define do
  factory :seat do
    council_session
    local_electoral_area
    councillor

    trait :active do
      sequence(:commenced_on) { |n| (n.years.ago).to_date }
    end
  end
end