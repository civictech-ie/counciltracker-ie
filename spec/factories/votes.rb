FactoryBot.define do
  factory :vote do
    councillor
    association :voteable, factory: :motion
    status { 'for' }
  end
end