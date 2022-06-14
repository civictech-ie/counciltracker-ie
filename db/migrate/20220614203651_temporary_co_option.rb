class TemporaryCoOption < ActiveRecord::Migration[6.1]
  def change
    date = Date.new(2022, 6, 1)
    session = CouncilSession.current_on(date).take
    CoOption.create(
      occurred_on: date,
      outgoing_seat: session.seats.find_by_councillor_name("Tina MacVeigh"),
      incoming_councillor: Councillor.find_or_create_by(full_name: "Deirdre Cronin", dcc_id: "1060"),
      incoming_party: Party.find_by(slug: "people-before-profit")
    )
  end
end
