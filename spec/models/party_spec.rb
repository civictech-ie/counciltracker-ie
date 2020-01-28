require "rails_helper"

RSpec.describe Party, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug).case_insensitive }
end
