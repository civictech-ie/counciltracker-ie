FactoryBot.define do
  factory :council_session do
    sequence(:commenced_on) { |n| (n.years.ago).to_date }
  end
end