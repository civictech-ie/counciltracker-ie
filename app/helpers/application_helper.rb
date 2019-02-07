module ApplicationHelper
  def summarize_event_for_councillor(event, councillor)
    case event.eventable_type.downcase
    when 'election'
      "Elected with #{ event.related_seat_ids.count - 1 } other councillors"
    when 'changeofaffiliation'
      "Changed party affiliation from #{ link_to event.eventable.outgoing_party.name, event.eventable.outgoing_party } to #{ link_to event.eventable.incoming_party.name, event.eventable.incoming_party }"
    when 'cooption'
      "#{ link_to event.eventable.outgoing_seat.councillor.full_name, event.eventable.outgoing_seat.councillor } resigned from the council and was replaced by #{ link_to event.eventable.incoming_seat.councillor.full_name, event.eventable.incoming_seat.councillor }"
    else
      raise "Must implement summary for #{ event.eventable_type }"
    end
  end

  def status_from_vote_result(result)
    case result
    when 'pass' then 'for'
    when 'fail' then 'against'
    when 'error' then 'abstain'
    end
  end

  def indefinitly_article(word)
    %w(a e i o u).include?(word[0].downcase) ? "an #{ word }" : "a #{ word }"
  end
end
