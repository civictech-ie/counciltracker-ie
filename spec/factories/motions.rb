FactoryBot.define do
  factory :motion do
    meeting

    sequence(:agenda_item)
    vote_ruleset { 'plurality' }
    vote_method { 'voice' }
    vote_result { 'pass' }

    trait :failed do
      vote_result { 'fail' }
    end
  end
end