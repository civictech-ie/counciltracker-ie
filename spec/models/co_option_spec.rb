require 'rails_helper'

RSpec.describe CoOption, type: :model do
  it { should validate_presence_of(:occurred_on) }
  it { should validate_presence_of(:outgoing_seat) }
  it { should validate_presence_of(:incoming_councillor) }
  it { should validate_presence_of(:incoming_party) }

  context "there is an active seat" do
    let(:seat) { create(:seat, commenced_on: 2.weeks.ago) }
    let(:co_option) { create(:co_option, occurred_on: 1.week.ago, outgoing_seat: seat) }

    it "has two related seats when the event has been committed" do
      co_option.reload
      expect(co_option.related_seat_ids.length).to eq(2)
    end

    it "switches the outgoing councillor with the incoming councillor" do
      outgoing_councillor = seat.councillor
      incoming_councillor = co_option.incoming_councillor

      # before the co-option, the incoming councillor is not active and the outgoing councillor is
      expect(outgoing_councillor.active_on?(co_option.occurred_on - 1.day)).to eq(true)
      expect(incoming_councillor.active_on?(co_option.occurred_on - 1.day)).to eq(false)

      co_option.reload
      incoming_councillor.reload

      # before the co-option, the outgoing councillor is not active and the incoming councillor is
      expect(incoming_councillor.active_on?(co_option.occurred_on + 1.day)).to eq(true)
      expect(outgoing_councillor.active_on?(co_option.occurred_on + 1.day)).to eq(false)
    end
  end
end