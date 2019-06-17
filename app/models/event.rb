class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true, dependent: :destroy

  validates :eventable, presence: true
  validates :occurred_on, presence: true

  after_create :commit!
  before_destroy :rollback!

  before_validation :set_occurred_on, :set_related_seat_ids

  scope :uncommitted, -> { where("committed_at IS NULL") }
  scope :by_occurred_on, -> { order("events.occurred_on desc") }
  scope :related_to_seat, -> (id) { where('related_seat_ids @> ?', "{#{ id }}") }
  scope :related_to_seats, -> (ids) { where('related_seat_ids && ARRAY[?]::bigint[]', ids) }
  scope :co_option, -> { where(eventable_type: 'CoOption') }
  scope :change_of_affiliation, -> { where(eventable_type: 'ChangeOfAffiliation') }
  scope :election, -> { where(eventable_type: 'Election') }

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

  def council_session
    @council_session ||= CouncilSession.current_on(self.occurred_on).take
  end

  private

  def set_occurred_on
    return unless eventable && eventable.occurred_on.present?
    self.occurred_on = eventable.occurred_on
  end

  def set_related_seat_ids
    return unless eventable
    self.related_seat_ids = eventable.related_seat_ids
  end
end
