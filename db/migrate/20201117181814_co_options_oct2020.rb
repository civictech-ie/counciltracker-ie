class CoOptionsOct2020 < ActiveRecord::Migration[6.0]
  def change
    date = Date.new(2020, 10, 1)
    session = CouncilSession.current_on(date).take
    CoOption.create(
      occurred_on: date,
      outgoing_seat: session.seats.find_by_councillor_name("Mary Fitzpatrick"),
      incoming_councillor: Councillor.find_or_create_by(full_name: "Eimer McCormack", dcc_id: "966"),
      incoming_party: Party.find_by(slug: "fianna-fail")
    )
    CoOption.create(
      occurred_on: date,
      outgoing_seat: session.seats.find_by_councillor_name("Críona Ní Dhálaigh"),
      incoming_councillor: Councillor.find_or_create_by(full_name: "Máire Devine", dcc_id: "961"),
      incoming_party: Party.find_by(slug: "sinn-fein")
    )
  end
end
