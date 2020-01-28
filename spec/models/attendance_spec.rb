require "rails_helper"

RSpec.describe Attendance, type: :model do
  it { should validate_presence_of(:councillor) }
  it { should validate_presence_of(:status) }

  it "should be invalid if the councillor is not on the council" do
    build(:council_session, commenced_on: 1.week.ago.to_date)
    councillor = build(:councillor)
    meeting = build(:meeting, occurred_on: Date.current)
    attendance = build(:attendance, attendable: meeting, councillor: councillor)
    expect(attendance.valid?).to be false
  end

  it "should be valid if the councillor is on the council" do
    build(:council_session, commenced_on: 1.week.ago.to_date)
    councillor = build(:councillor)
    create(:seat, councillor: councillor, commenced_on: 1.week.ago.to_date)
    meeting = build(:meeting, occurred_on: Date.current)
    attendance = build(:attendance, attendable: meeting, councillor: councillor)
    expect(attendance.valid?).to be true
  end
end
