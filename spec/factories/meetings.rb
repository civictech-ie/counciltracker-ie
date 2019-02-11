FactoryBot.define do
  factory :meeting do
    council_session

    sequence(:agenda_item)
    sequence(:occurred_on) { |n| n.days.ago.to_date2 }
    meeting_type { 'monthly' }
  end
end