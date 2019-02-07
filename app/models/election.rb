require 'csv'

class Election < Eventable
  def self.create_from_date_and_csv!(date, csv_file)
    rows = CSV.parse(csv_file, headers: true)
    councillors = rows.map do |row|
      {
        party_name: row['Party'].strip,
        councillor_name: row['Name'].strip,
        local_electoral_area_name: row['Local Electoral Area'].strip
      }
    end

    create! occurred_on: date, parameters: councillors
  end

  def commit! # replace names with ids
    raise('Missing event') unless event.present?
    raise('Missing council session') unless event.council_session.present?

    self.parameters = parameters.map do |row|
      seat = Seat.create!(
        council_session: event.council_session,
        party: Party.find_or_create_by!(name: row['party_name']),
        councillor: Councillor.find_or_create_by!(full_name: row['councillor_name']),
        local_electoral_area: LocalElectoralArea.find_or_create_by!(name: row['local_electoral_area_name']),
        commenced_on: event.occurred_on
      )

      row.merge({seat_id: seat.id})
    end
    save!
  end

  def rollback! # replace ids with names
    raise('Missing event') unless event.present?
    raise('Missing council session') unless event.council_session.present?

    self.parameters = parameters.map do |row|
      seat = event.council_session.seats.find(row['seat_id'])
      seat.destroy!

      row.delete(:seat_id)
      row
    end
    save!
  end

  def related_seat_ids
    return [] unless parameters.present? && parameters.any?
    parameters.map { |row| row['seat_id'] }.compact
  end
end
