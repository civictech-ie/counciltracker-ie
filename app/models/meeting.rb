class Meeting < ApplicationRecord
  belongs_to :council_session, touch: true

  has_many :motions, dependent: :destroy
  has_many :attendances, dependent: :destroy, as: :attendable
  has_many :councillors, through: :attendances

  before_validation :set_council_session
  after_validation :set_hashed_id, if: ->(m) { m.hashed_id.blank? }
  after_save :clean_attendances

  validates :council_session, presence: true
  validates :occurred_on, presence: true, uniqueness: {scope: :meeting_type}
  validates :meeting_type, presence: true, inclusion: %w[monthly annual special budget finance]

  scope :by_occurred_on, -> { order("occurred_on desc") }
  scope :has_countable_attendances, -> { joins(:attendances).merge(Attendance.countable).distinct }
  scope :has_published_motions, -> { joins(:motions).merge(Motion.published).distinct }

  paginates_per 20

  def to_param
    hashed_id
  end

  def path
    "/meetings/#{meeting_type}/#{occurred_on}"
  end

  def title
    "#{meeting_type_in_english} on #{occurred_on.strftime("%-d %B '%y")}"
  end

  def occurred_on_formatted
    occurred_on.strftime("%-d %B '%y")
  end

  def tags
    motions.map(&:tags).flatten.uniq
  end

  def meeting_type_in_english
    case meeting_type.to_s
    when "monthly" then "Monthly Council Meeting"
    when "annual" then "Annual Council Meeting"
    when "special" then "Special Council Meeting"
    when "budget" then "Budget Meeting"
    when "finance" then "Finance Special Council Meeting"
    end
  end

  # todo: rename to expected_councillors?
  def expected_attendance
    return nil unless council_session
    council_session.councillors.active_on(occurred_on)
  end

  private

  def set_council_session
    self.council_session = CouncilSession.current_on(occurred_on).take
  end

  def set_hashed_id
    self.hashed_id = SecureRandom.hex(4)
  end

  def clean_attendances
    expected_councillors = expected_attendance.to_a

    attendances.each do |a|
      c = expected_councillors.delete(a.councillor)
      a.destroy! if c.nil?
    end

    expected_councillors.each do |councillor|
      a = attendances.new(councillor: councillor, status: "exception")
      a.save!
    end
  end
end
