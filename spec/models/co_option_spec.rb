require 'rails_helper'

RSpec.describe CoOption, type: :model do
  it { should validate_presence_of(:occurred_on) }
  it { should validate_presence_of(:outgoing_seat) }
  it { should validate_presence_of(:incoming_councillor) }
  it { should validate_presence_of(:incoming_party) }

  context "there is an active seat" do
    let(:seat) { create(:seat, commenced_on: 2.weeks.ago) }
    let(:co_option) { create(:co_option, occurred_on: 1.week.ago, outgoing_seat: seat) }

    it "has one related seat when the event hasn't been committed" do
      expect(co_option.related_seat_ids.length).to eq(1)
    end

    it "has two related seats when the event has been committed" do
      co_option.commit!
      co_option.reload
      expect(co_option.related_seat_ids.length).to eq(2)
    end
  end
end