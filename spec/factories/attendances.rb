FactoryBot.define do
  factory :attendance do
    councillor
    status { 'present' }
  end
end