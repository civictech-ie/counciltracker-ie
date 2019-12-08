class Motion < Voteable
  belongs_to :meeting, touch: true

  has_many :amendments, dependent: :destroy
  has_many :media_mentions, as: :mentionable

  validates :official_reference, presence: true, uniqueness: { scope: :meeting_id }
  validates :title, presence: true
  validates :meeting, presence: true
  validates :position, presence: true
  validates :agenda_item, presence: true
  validates :executive_vote, inclusion: %w(for against abstain absent), allow_blank: true

  before_validation :cleanup_agenda_item, :set_official_reference, :set_position, :cleanup_tags
  after_validation :set_hashed_id, if: -> (m) { m.hashed_id.blank? }

  scope :by_position, -> { order('position asc') }
  scope :by_occurred_on, -> { includes(:meeting).order('meetings.occurred_on desc') }
  scope :proposed_by, -> (c) { where('proposers_ids @> ?', "{#{ c.id }}") }
  scope :in_category, -> (c) { where('tags @> ?', "{#{ c.downcase }}") }
  scope :related_to_area, -> (a) { where('local_electoral_area_ids @> ?', "{#{ a.id }}") }
  scope :published, -> { where.not(published_at: nil) }

  delegate :occurred_on, to: :meeting

  paginates_per 20

  def to_param
    self.hashed_id
  end

  def council_session
    self.meeting.council_session
  end

  def local_electoral_areas
    @local_electoral_areas ||= LocalElectoralArea.where(id: self.local_electoral_area_ids)
  end

  def proposers
    @proposers ||= Councillor.where(id: self.proposers_ids).by_name
  end

  def self.cleanup_agenda_item(itm)
    itm.gsub(/[)()]/,'').downcase
  end

  def attachments
    [self.pdf_url]
  end

  def meeting_date
    self.occurred_on
  end

  def is_votable?
    self.votable
  end

  def is_published?
    self.published_at.present?
  end

  def toggle_publication!
    is_published? ? unpublish! : publish!
  end

  def publish!
    self.update(published_at: Time.zone.now)
  end

  def unpublish!
    self.update(published_at: nil)
  end

  def in_category?(cat)
    self.tags.include?(cat.downcase)
  end

  def as_json(options={})
    super(only: [:title, :votable, :hashed_id], methods: [:result, :meeting_date])
  end

  private

  def cleanup_tags
    self.tags = self.tags.map(&:downcase)
  end

  def cleanup_agenda_item
    return if self.agenda_item.blank?
    self.agenda_item = self.class.cleanup_agenda_item(agenda_item)
  end

  def set_position
    return if self.agenda_item.blank?
    return if self.agenda_item.scan(/(\d+)/).empty?

    top_level_int = self.agenda_item.scan(/(\d+)/).first.first.to_i
    self.position = if self.agenda_item.scan(/([a-z])/i).any?
      second_level_alpha = self.agenda_item.scan(/([a-z])/i).first.first.downcase
      alpha_val = (("a".."z").to_a.index(second_level_alpha) + 1)
      ((top_level_int * 100) + alpha_val)
    else
      (top_level_int * 100)
    end
  end

  def set_official_reference
    return unless self.meeting
    self.official_reference = "#{ self.meeting.meeting_type }-#{ self.occurred_on.to_s.gsub('-','') }-#{ self.agenda_item }"
  end

  def set_hashed_id
    self.hashed_id = SecureRandom.hex(4)
  end
end
