class Event < ApplicationRecord
  belongs_to :council_session
  belongs_to :eventable, polymorphic: true, dependent: :destroy

  validates :occurred_on, presence: true

  before_validation :set_occurred_on, :set_council_session, :set_related_seat_ids

  scope :uncommitted, -> { where("committed_at IS NULL") }
  scope :by_occurred_on, -> { order("events.occurred_on desc") }
  scope :related_to_seat, -> (id) { where('related_seat_ids @> ?', "{#{ id }}") }

  def commit!
    raise "Can't commit unless uncommitted" unless !committed?
    self.eventable.commit!
    self.update! committed_at: Time.zone.now
  end

  def rollback!
    raise "Can't rollback unless committed" unless committed?
    self.eventable.rollback!
    self.update! committed_at: nil
  end

  def committed?
    self.committed_at.present?
  end

  def seats
    Seat.where id: self.related_seat_ids
  end

  private

  def set_occurred_on
    return unless eventable.occurred_on.present?
    self.occurred_on = eventable.occurred_on
  end

  def set_council_session
    self.council_session = CouncilSession.current_on(self.occurred_on).take
  end

  def set_related_seat_ids
    raise "Setting related ids without eventable" if !self.eventable.present?
    self.related_seat_ids = eventable.related_seat_ids
  end
end
