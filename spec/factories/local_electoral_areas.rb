FactoryBot.define do
  factory :local_electoral_area do
    sequence(:name) { |n| "District #{ n }"}
  end
end