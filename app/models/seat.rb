class Seat < ApplicationRecord
  belongs_to :council_session, touch: true
  belongs_to :local_electoral_area, touch: true
  belongs_to :councillor, touch: true

  has_many :party_affiliations, autosave: true, dependent: :destroy

  validates :council_session, presence: true
  validates :local_electoral_area, presence: true
  validates :councillor, presence: true

  delegate :full_name, to: :councillor

  scope :inactive, -> { inactive_on(Date.today) }
  scope :active, -> { active_on(Date.today) }
  scope :inactive_on, ->(date) { where("(seats.commenced_on <= ?) AND (seats.concluded_on <= ?)", date, date) }
  scope :active_on, ->(date) { where("(seats.commenced_on <= ?) AND ((seats.concluded_on IS NULL) OR (seats.concluded_on > ?))", date, date) }

  # should only be one per councillor per council_session
  def self.find_by_councillor_name(name)
    joins(:councillor).where(councillors: {full_name: name}).take
  end

  def party
    @party ||= party_affiliations.order("commenced_on DESC NULLS LAST").take.try(:party)
  end

  def party=(party)
    raise "Can only be used to set initial party" if party_affiliations.any?
    party_affiliations.build(party: party, commenced_on: nil)
  end

  def set_party_affiliation_starting_on(party, date)
    party_affiliations.create(party: party, commenced_on: date)
  end

  def events
    @events ||= council_session.events.where("related_seat_ids @> ARRAY[CAST(? as bigint)]", id).order("occurred_on desc")
  end

  def election
    events.election.take
  end
end
