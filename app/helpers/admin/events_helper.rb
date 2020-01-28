module Admin::EventsHelper
  def admin_summarize_event(event)
    case event.eventable_type.downcase
    when "election"
      "#{event.related_seat_ids.count} elected"
    when "changeofaffiliation"
      "#{event.eventable.councillor.full_name} changed party affiliation from #{event.eventable.outgoing_party.name} to #{event.eventable.incoming_party.name}"
    when "cooption"
      "#{event.eventable.outgoing_seat.councillor.full_name} resigned from the council and was replaced by #{event.eventable.incoming_seat.councillor.full_name}"
    else
      raise "Must implement summary for #{event.eventable_type}"
    end
  end
end
