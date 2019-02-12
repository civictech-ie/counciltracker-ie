class ChangeOfAffiliation < Eventable
  belongs_to :councillor
  belongs_to :outgoing_party, class_name: 'Party'
  belongs_to :incoming_party, class_name: 'Party'

  validates :councillor, presence: true
  validates :outgoing_party, presence: true
  validates :incoming_party, presence: true

  def commit!
    raise "No current seat" unless seat.present?
    raise "Outgoing party doesn't match" unless seat.party == outgoing_party

    seat.party = incoming_party
    seat.save!
    save!
  end

  def rollback!
    raise "No current seat" unless seat.present?
    raise "Incoming party doesn't match" unless seat.party == incoming_party

    seat.party = outgoing_party
    seat.save!
    save!
  end

  def related_seat_ids
    @related_seat_ids ||= [seat.try(:id)].compact
  end

  def seat
    return nil unless event.present?
    @seat ||= councillor.seats.active_on(event.occurred_on).take
  end
end
