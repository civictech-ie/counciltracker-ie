require 'csv'

class Election < Eventable
  attribute :election_csv

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

    council_session = CouncilSession.create!(commenced_on: event.occurred_on)

    self.parameters = parameters.map do |row|
      seat = Seat.create!(
        council_session: council_session,
        councillor: Councillor.find_or_create_by!(full_name: row['councillor_name']),
        local_electoral_area: LocalElectoralArea.find_or_create_by!(name: row['local_electoral_area_name']),
        commenced_on: event.occurred_on
      )

      seat.party_affiliations.create!(party: Party.find_or_create_by!(name: row['party_name']))

      row.merge({seat_id: seat.id})
    end

    # should only be one
    CouncilSession.where(concluded_on: nil).where.not(id: council_session.id).each do |old_session|
      old_session.concluded_on = (event.occurred_on - 1.day).to_date
      old_session.save!
    end

    save!
  end

  def rollback! # replace ids with names
    raise('Missing event') unless event.present?

    self.parameters = parameters.map do |row|
      seat = Seat.find(row['seat_id'])
      seat.destroy!

      row.delete(:seat_id)
      row
    end

    council_session = CouncilSession.find_by!(commenced_on: event.occurred_on)
    council_session.destroy!

    save!
  end

  def related_seat_ids
    return [] unless parameters.present? && parameters.any?
    parameters.map { |row| row['seat_id'] }.compact
  end
end
