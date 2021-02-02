class ChangeOfAffiliationJan2021 < ActiveRecord::Migration[6.1]
  def change
    date = Date.new(2021, 1, 15)
    session = CouncilSession.current_on(date).take
    
    ChangeOfAffiliation.create(
      occurred_on: date,
      councillor: session.seats.find_by_councillor_name("sophie-nicoullaud"),
      outgoing_party: Party.find_by(slug: "green-party"),
      incoming_party: Party.find_by(slug: "independent")
    )
  end
end