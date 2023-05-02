class TemporaryCoOptionFeb23 < ActiveRecord::Migration[6.1]
  def change
    date = Date.new(2023, 2, 13)
    session = CouncilSession.current_on(date).take
    CoOption.create(
      occurred_on: date,
      outgoing_seat: session.seats.find_by_councillor_name("Catherine Stocker"),
      incoming_councillor: Councillor.find_or_create_by(full_name: "Karl Stanley", dcc_id: "1105"),
      incoming_party: Party.find_by(slug: "social-democrats")
    )
  end
end
13 February 2023