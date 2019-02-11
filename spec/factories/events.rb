FactoryBot.define do
  factory :event do
    council_session
    eventable { change_of_affiliation }
    occurred_on { 1.month.ago.to_date }
  end
end