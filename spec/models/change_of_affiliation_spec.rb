require "rails_helper"

RSpec.describe ChangeOfAffiliation, type: :model do
  it { should validate_presence_of(:occurred_on) }
  it { should validate_presence_of(:councillor) }
  it { should validate_presence_of(:outgoing_party) }
  it { should validate_presence_of(:incoming_party) }

  context "there is an active seat" do
    let(:outgoing_party) { create(:party) }
    let(:seat) { create(:seat, commenced_on: 2.years.ago, party: outgoing_party) }
    let(:change_of_affiliation) { create(:change_of_affiliation, councillor: seat.councillor, outgoing_party: outgoing_party, occurred_on: 1.year.ago) }

    # it "knows its related seats" do
    #   change_of_affiliation.reload
    #   expect(change_of_affiliation.related_seat_ids).to include(seat.id)
    # end

    # it "can guess its seat" do
    #   expect(change_of_affiliation.seat).to eq seat
    # end

    # it "can make the change" do
    #   change_of_affiliation.reload
    #   expect(seat.party).to eq change_of_affiliation.incoming_party
    # end

    # it "can unmake the change" do
    #   change_of_affiliation.commit! if !change_of_affiliation.committed?
    #   seat.reload
    #   change_of_affiliation.rollback!
    #   seat.reload
    #   expect(seat.party).to eq change_of_affiliation.outgoing_party
    # end
  end
end
