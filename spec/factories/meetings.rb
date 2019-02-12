FactoryBot.define do
  factory :meeting do
    council_session

    sequence(:occurred_on) { |n| n.days.ago.to_date }
    meeting_type { 'monthly' }
  end
end