class Amendment < ApplicationRecord
  belongs_to :motion, touch: true

  has_many :votes, as: :voteable, dependent: :destroy
  has_many :councillors, through: :votes

  accepts_nested_attributes_for :votes

  validates :vote_ruleset, inclusion: %w(plurality absolute_majority super_majority), allow_blank: false
  validates :vote_method, inclusion: %w(voice rollcall), allow_blank: false
  validates :vote_result, inclusion: %w(pass fail error), allow_blank: false

  validates :official_reference, presence: true, uniqueness: { scope: :motion_id }
  validates :position, presence: true

  before_validation :set_official_reference
  before_validation :append_to_motion, if: -> (m) { m.position.blank? }
  after_validation :set_hashed_id, if: -> (m) { m.hashed_id.blank? }
  after_validation :determine_vote_result, if: -> (m) { m.rollcall? }
  after_save :clean_votes, if: -> (m) { m.rollcall? }
  after_save :destroy_votes, if: -> (m) { !m.rollcall? }

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

  def result
    self.vote_result
  end

  def rollcall?
    (self.vote_method == 'rollcall')
  end

  def proposers
    Councillor.where(id: self.proposers_ids)
  end

  def refresh_hashed_id!
    set_hashed_id
    save!
  end

  private

  def append_to_motion
    raise "Can't override present position" if position.present?
    self.position = (self.motion.amendments.map(&:position).max || 0) + 1
  end

  def set_official_reference
    self.official_reference = "#{ self.motion.official_reference }-#{ self.position }-#{ SecureRandom.hex(2) }"
  end

  def set_hashed_id
    self.hashed_id = SecureRandom.hex(4)
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
end
