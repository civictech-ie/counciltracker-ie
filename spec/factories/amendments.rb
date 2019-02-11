FactoryBot.define do
  factory :amendment do
    motion

    sequence(:official_reference) { |n| "ofref#{n}" }
    vote_ruleset { 'plurality' }
    vote_method { 'voice' }
    vote_result { 'pass' }

    trait :failed do
      vote_result { 'fail' }
    end
  end
end