FactoryBot.define do
  factory :media_mention do
    body { 'a real turn up for the books' }
    mentionable { motion }
  end
end