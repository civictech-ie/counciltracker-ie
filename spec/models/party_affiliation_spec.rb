require "rails_helper"

RSpec.describe PartyAffiliation, type: :model do
  it { should validate_presence_of(:party) }
  it { should validate_presence_of(:seat) }
end
