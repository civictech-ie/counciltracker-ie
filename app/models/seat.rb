class Seat < ApplicationRecord
  belongs_to :council_session, touch: true
  belongs_to :local_electoral_area, touch: true
  belongs_to :councillor, touch: true
  belongs_to :party, touch: true

  delegate :full_name, to: :councillor

  scope :active, -> { active_on(Date.today) }
  scope :active_on, -> (date) { where('(seats.commenced_on <= ?) AND ((seats.concluded_on IS NULL) OR (seats.concluded_on > ?))', date, date) }

  def self.find_by_councillor_name(name) # should only be one per councillor per council_session
    joins(:councillor).where(councillors: {full_name: name}).take
  end

  def events
    council_session.events.where 'related_seat_ids @> ARRAY[CAST(? as bigint)]', self.id
  end
end
