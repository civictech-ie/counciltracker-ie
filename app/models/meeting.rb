class Meeting < ApplicationRecord
  belongs_to :council_session, touch: true

  has_many :motions, dependent: :destroy
  has_many :attendances, dependent: :destroy, as: :attendable
  has_many :councillors, through: :attendances

  before_validation :set_council_session
  after_validation :set_hashed_id, if: -> (m) { m.hashed_id.blank? }
  after_save :clean_attendances

  validates :council_session, presence: true
  validates :occurred_on, presence: true, uniqueness: { scope: :meeting_type }
  validates :meeting_type, presence: true, inclusion: %w(monthly annual special budget finance)

  scope :by_occurred_on, -> { order('occurred_on desc') }
  scope :has_countable_attendances, -> { joins(:attendances).merge(Attendance.countable).distinct }

  accepts_nested_attributes_for :attendances, reject_if: :incomplete_attendance

  def to_param
    self.hashed_id
  end

  def title
    "#{ self.meeting_type_in_english } #{ occurred_on.strftime('%d.%m.%y') }"
  end

  def meeting_type_in_english
    case meeting_type.to_s
    when 'monthly' then 'Monthly Council Meeting'
    when 'annual' then 'Annual Council Meeting'
    when 'special' then 'Special Council Meeting'
    when 'budget' then 'Budget Meeting'
    when 'finance' then 'Finance Special Council Meeting'
    end
  end

  def expected_attendance # todo: rename to expected_councillors?
    return nil unless self.council_session
    self.council_session.councillors.active_on(self.occurred_on)
  end

  def refresh_hashed_id!
    set_hashed_id
    save!
  end

  private

  def set_council_session
    self.council_session = CouncilSession.current_on(self.occurred_on).take
  end

  def set_hashed_id
    self.hashed_id = SecureRandom.hex(4)
  end

  def clean_attendances
    expected_councillors = expected_attendance.to_a

    self.attendances.each do |a|
      c = expected_councillors.delete(a.councillor)
      a.destroy! if c.nil?
    end

    expected_councillors.each do |councillor|
      a = self.attendances.new(councillor: councillor, status: 'exception')
      a.save!
    end
  end

  def incomplete_attendance(attributes)
    attributes['councillor_id'].blank? or
    attributes['status'].blank?
  end
end
