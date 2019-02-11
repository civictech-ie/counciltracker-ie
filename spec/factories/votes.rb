FactoryBot.define do
  factory :vote do
    councillor
    voteable { motion }
    status { 'for' }
  end
end