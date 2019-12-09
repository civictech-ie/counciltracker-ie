class Attendance < ApplicationRecord
  belongs_to :attendable, polymorphic: true, required: false, touch: true
  belongs_to :councillor, touch: true

  validates :councillor, presence: true
  validates :status, presence: true, inclusion: %w(present apologies absent expected exception)
  validate :councillor_on_council

  delegate :full_name, to: :councillor
  delegate :party, to: :councillor
  delegate :occurred_on, to: :attendable

  scope :countable, -> { where(status: ['present','expected', 'absent', 'apologies']) }
  scope :present, -> { where(status: 'present') }
  scope :attended, -> { where(status: ['present','expected']) }
  scope :apologies, -> { where(status: 'apologies') }
  scope :absent, -> { where(status: 'absent') }
  scope :expected, -> { where(status: 'expected') }
  scope :exception, -> { where(status: 'exception') }

  scope :presentish, -> { where(status: ['present','expected']) }
  scope :absentish, -> { where(status: ['absent','apologies']) }

  scope :by_status, -> { order('status asc') }
  scope :by_councillor_name, -> { joins(:councillor).order('councillors.sort_name asc') }
  scope :possible, -> { joins("LEFT JOIN meetings ON attendances.attendable_type = 'Meeting' AND attendances.attendable_id = meetings.id").
                        joins(councillor: :seats).
                        where('(seats.commenced_on <= meetings.occurred_on) AND ((seats.concluded_on IS NULL) OR (seats.concluded_on > meetings.occurred_on))') }
  
  def presentish?
    %w(present expected).include?(self.status)
  end

  private

  def councillor_on_council
    return true unless self.attendable
    if !self.councillor.active_on?(self.occurred_on)
      errors.add(:councillor, "Councillor is not on council on meeting date")
    end
  end
end
