require 'rails_helper'

RSpec.describe Amendment, type: :model do
  it { should validate_presence_of(:motion) }
  it { should validate_presence_of(:official_reference) }
  it { should validate_presence_of(:position) }
  it { should validate_presence_of(:vote_ruleset) }
  it { should validate_presence_of(:vote_method) }
  it { should validate_presence_of(:vote_result) }

  it "recognises rollcall votes" do
    amendment = build(:amendment, vote_method: 'rollcall')
    expect(amendment.rollcall?).to be true
  end

  it "recognises voice votes" do
    amendment = build(:amendment, vote_method: 'voice')
    expect(amendment.rollcall?).to be false
  end

  it "recognises voice votes" do
    councillor_1 = create(:councillor)
    councillor_2 = create(:councillor)

    amendment = build(:amendment, proposers_ids: [councillor_1.id, councillor_2.id])
    expect(amendment.proposers).to include(councillor_1)
    expect(amendment.proposers).to include(councillor_2)
  end
end