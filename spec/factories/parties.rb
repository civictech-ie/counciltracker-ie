FactoryBot.define do
  factory :party do
    sequence(:name) { |n| "Party #{n}" }
  end
end
