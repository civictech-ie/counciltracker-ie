class CoOption < Eventable
  belongs_to :outgoing_seat, class_name: 'Seat'
  belongs_to :incoming_councillor, class_name: 'Councillor'
  belongs_to :incoming_party, class_name: 'Party'

  validates :outgoing_seat, presence: true
  validates :incoming_councillor, presence: true
  validates :incoming_party, presence: true

  def commit!
    outgoing_seat.update(concluded_on: event.occurred_on)
    incoming_seat = Seat.create!(
      council_session: event.council_session,
      party: incoming_party,
      councillor: incoming_councillor,
      local_electoral_area: outgoing_seat.local_electoral_area,
      commenced_on: event.occurred_on
    )
    save!
  end

  def rollback!
    outgoing_seat.update(concluded_on: nil)
    incoming_seat.destroy!
    save!
  end

  def related_seat_ids
    [incoming_seat, outgoing_seat].compact.map(&:id)
  end

  def incoming_seat
    return nil unless event && event.committed?
    event.council_session.seats.find_by(councillor: incoming_councillor, party: incoming_party)
  end
end
