class Eventable < ApplicationRecord
  self.abstract_class = true

  has_one :event, as: :eventable
  attribute :occurred_on, :date

  validates :occurred_on, presence: true

  after_create :create_event

  def related_seat_ids
    raise "Must implement related_seats in sublcass"
  end

  def occurred_on
    @occurred_on ||= self.event.try(:occurred_on)
  end

  def occurred_on=(date)
    @occurred_on = date
  end

  def council_session
    @council_session ||= CouncilSession.current_on(occurred_on).take
  end

  private

  def create_event
    e = self.build_event
    e.occurred_on = self.occurred_on
    e.save!
  end
end
