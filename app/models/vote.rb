class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true, touch: true
  belongs_to :councillor, touch: true

  delegate :occurred_on, to: :voteable
  delegate :meeting, to: :voteable

  validates :status, presence: true, inclusion: %w(for against abstain absent not_voted exception), allow_blank: true
  validates :councillor, presence: true, uniqueness: { scope: :voteable }

  scope :missing, -> { where(status: '') }
  scope :countable, -> { where(status: %w(for against abstain)) }
  scope :in_favour, -> { where(status: 'for') }
  scope :in_opposition, -> { where(status: 'against') }
  scope :in_abstention, -> { where(status: 'abstain') }
  scope :in_absentia, -> { where(status: 'absent') }
  scope :by_status, -> { order('status desc') }
  scope :by_councillor_name, -> { joins(:councillor).order('councillors.sort_name asc') }

  after_save :update_attendance

  def seat
    councillor.seats.active_on(self.occurred_on).take
  end

  def party
    return nil unless self.seat
    self.seat.party
  end

  def implies_presence?
    %w(for against abstain not_voted).include? self.status.to_s
  end

  private

  def update_attendance
  end
end

