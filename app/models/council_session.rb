class CouncilSession < ApplicationRecord
  has_many :seats, dependent: :destroy
  has_many :meetings, dependent: :destroy

  has_many :motions, through: :meetings
  has_many :amendments, through: :motions

  has_many :councillors, -> { distinct }, through: :seats

  has_many :parties, -> { distinct }, through: :seats
  has_many :local_electoral_areas, -> { distinct }, through: :seats

  has_many :active_seats, -> { active }, class_name: 'Seat'
  has_many :active_councillors, source: :councillor, through: :active_seats

  validates :commenced_on, presence: true

  scope :current_on, -> (date) { where('(commenced_on <= ?) AND ((concluded_on IS NULL) OR (concluded_on > ?))', date, date) }

  def events
    Event.where(occurred_on: [commenced_on...concluded_on])
  end

  def election
    self.events.find_by(eventable_type: 'Election')
  end

  def co_options
    self.events.where(eventable_type: 'CoOption')
  end

  def change_of_affiliations
    self.events.where(eventable_type: 'ChangeOfAffiliation')
  end

  def to_param
    self.commenced_on.to_s
  end

  def self.latest
    order('commenced_on desc').take
  end

  def self.current
    current_on(Date.current).take
  end

  def election
    self.events.where(eventable_type: 'Election').take
  end
end
