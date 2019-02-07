class Motion < ApplicationRecord
  belongs_to :meeting, touch: true

  has_many :votes, as: :voteable, dependent: :destroy
  has_many :amendments, dependent: :destroy
  has_many :media_mentions, as: :mentionable
  has_many :councillors, through: :votes

  accepts_nested_attributes_for :votes

  validates :vote_ruleset, inclusion: %w(plurality absolute_majority super_majority), allow_blank: false
  validates :vote_method, inclusion: %w(voice rollcall), allow_blank: false
  validates :vote_result, inclusion: %w(pass fail error), allow_blank: false

  validates :official_reference, presence: true, uniqueness: { scope: :meeting_id }
  validates :position, presence: true
  validates :agenda_item, presence: true
  validates :executive_vote, inclusion: %w(for against abstain absent), allow_blank: true

  before_validation :cleanup_agenda_item, :set_official_reference, :set_position, :cleanup_tags
  after_validation :set_hashed_id, if: -> (m) { m.hashed_id.blank? }
  after_validation :determine_vote_result, if: -> (m) { m.rollcall? }
  after_save :clean_votes, if: -> (m) { m.rollcall? }
  after_save :destroy_votes, if: -> (m) { !m.rollcall? }

  scope :by_position, -> { order('position asc') }
  scope :by_occurred_on, -> { includes(:meeting).order('meetings.occurred_on desc') }
  scope :proposed_by, -> (c) { where('proposers_ids @> ?', "{#{ c.id }}") }
  scope :in_category, -> (c) { where('tags @> ?', "{#{ c.downcase }}") }
  scope :related_to_area, -> (a) { where('local_electoral_area_ids @> ?', "{#{ a.id }}") }
  scope :has_countable_votes, -> { joins(:votes).merge(Vote.countable).distinct }
  scope :published, -> { where.not(published_at: nil) }
  scope :interesting, -> { where(interesting: true) }

  delegate :occurred_on, to: :meeting

  def to_param
    self.hashed_id
  end

  def result
    self.vote_result
  end

  def council_session
    self.meeting.council_session
  end

  def rollcall?
    (self.vote_method == 'rollcall')
  end

  def local_electoral_areas
    LocalElectoralArea.where id: self.local_electoral_area_ids
  end

  def proposers
    Councillor.where(id: self.proposers_ids)
  end

  def self.cleanup_agenda_item(itm)
    itm.gsub(/[)()]/,'').downcase
  end

  def meeting_date
    self.meeting.occurred_on
  end

  def is_votable?
    self.votable
  end

  def is_interesting?
    self.interesting
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

  def mark_as_interesting!
    self.update_column(:interesting, true)
  end

  def in_category?(cat)
    self.tags.include?(cat.downcase)
  end

  def refresh_hashed_id!
    set_hashed_id
    save!
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
    self.official_reference = "#{ self.meeting.meeting_type }-#{ self.meeting.occurred_on.to_s.gsub('-','') }-#{ self.agenda_item }"
  end

  def determine_vote_result
    self.vote_result = case self.vote_ruleset.to_sym
    when :plurality
      if self.votes.in_favour.count > self.votes.in_opposition.count
        'pass'
      else
        'fail'
      end
    when :absolute_majority
      if self.votes.in_favour.count >= 32 # todo: make dynamic based on councillor count
        'pass'
      else
        'fail'
      end
    when :super_majority
      if self.votes.in_favour.count >= 42 # todo: make dynamic based on councillor count
        'pass'
      else
        'fail'
      end
    else
      'error'
    end

    true
  end

  def clean_votes
    expected_voters = self.meeting.councillors.to_a

    self.votes.each do |v|
      c = expected_voters.delete(v.councillor)
      v.destroy! if c.nil?
    end

    expected_voters.each do |councillor|
      a = self.meeting.attendances.find_by(councillor: councillor)
      status = if a.status == 'absent'
        'absent'
      else
        'exception'
      end

      v = self.votes.new(councillor: councillor, status: status)
      v.save!
    end
  end

  def destroy_votes
    return true if self.votes.countable.any? # TODO: delete these
    self.votes.destroy_all
  end

  def set_hashed_id
    self.hashed_id = SecureRandom.hex(4)
  end
end
