class CoOptions2020 < ActiveRecord::Migration[6.0]
  def change
    date = Date.new(2020, 2, 1)
    session = CouncilSession.current_on(date).take
    CoOption.create(
      occurred_on: date,
      outgoing_seat: session.seats.find_by_councillor_name("Paul McAuliffe"),
      incoming_councillor: Councillor.find_or_create_by(full_name: "Briege Mac Oscar"),
      incoming_party: Party.find_by(slug: "fianna-fail")
    )
    CoOption.create(
      occurred_on: date,
      outgoing_seat: session.seats.find_by_councillor_name("Chris Andrews"),
      incoming_councillor: Councillor.find_or_create_by(full_name: "Daniel Céitinn"),
      incoming_party: Party.find_by(slug: "sinn-fein")
    )
    CoOption.create(
      occurred_on: date,
      outgoing_seat: session.seats.find_by_councillor_name("Patrick Costello"),
      incoming_councillor: Councillor.find_or_create_by(full_name: "Carolyn Moore"),
      incoming_party: Party.find_by(slug: "green-party")
    )
    CoOption.create(
      occurred_on: date,
      outgoing_seat: session.seats.find_by_councillor_name("Neasa Hourigan"),
      incoming_councillor: Councillor.find_or_create_by(full_name: "Darcy Lonergan"),
      incoming_party: Party.find_by(slug: "green-party")
    )
    CoOption.create(
      occurred_on: date,
      outgoing_seat: session.seats.find_by_councillor_name("Gary Gannon"),
      incoming_councillor: Councillor.find_or_create_by(full_name: "Cat O'Driscoll"),
      incoming_party: Party.find_by(slug: "social-democrats")
    )
  end
end
