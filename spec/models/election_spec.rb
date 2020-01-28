require "rails_helper"

RSpec.describe Election, type: :model do
  it { should validate_presence_of(:occurred_on) }
  it { should validate_presence_of(:parameters) }
end
