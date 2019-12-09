class Amendment < Voteable
  belongs_to :motion, touch: true

  validates :official_reference, presence: true, uniqueness: { scope: :motion_id }
  validates :position, presence: true
  validates :motion, presence: true

  before_validation :set_official_reference
  before_validation :append_to_motion, if: -> (m) { m.position.blank? }
  after_validation :set_hashed_id, if: -> (m) { m.hashed_id.blank? }

  delegate :council_session, to: :motion
  delegate :meeting, to: :motion
  delegate :occurred_on, to: :meeting

  scope :by_position, -> { order('position asc') }
  scope :by_occurred_on, -> { joins(motion: :meeting).order('meetings.occurred_on desc') }
  scope :proposed_by, -> (c) { where('amendments.proposers_ids @> ?', "{#{ c.id }}") }
  scope :published, -> { joins(:motion).merge(Motion.published) }

  def to_param
    self.hashed_id
  end

  def proposers
    @proposers ||= Councillor.where(id: self.proposers_ids)
  end

  def attachments
    [self.pdf_url]
  end

  private

  def append_to_motion
    raise "Can't override present position" if position.present?
    return unless self.motion
    self.position = (self.motion.amendments.maximum(:position) || 0) + 1
  end

  def set_official_reference
    return unless self.motion && self.meeting
    self.official_reference = "#{ self.motion.official_reference }-#{ self.position }-#{ SecureRandom.hex(2) }"
  end

  def set_hashed_id
    self.hashed_id = SecureRandom.hex(4)
  end
end
