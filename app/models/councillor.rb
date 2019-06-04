class Councillor < ApplicationRecord
  has_many :seats
  has_many :attendances
  has_many :votes
  has_many :media_mentions, as: :mentionable

  has_many :meetings, through: :attendances
  has_many :motions, through: :votes

  validates :full_name, presence: true

  before_validation :set_full_name, if: -> (c) { c.given_name_changed? or c.family_name_changed? }
  before_validation :set_given_and_family_names, if: -> (c) { c.full_name_changed? }
  before_validation :generate_sort_name
  after_validation :generate_slug

  scope :by_name, -> { order('sort_name asc') }
  scope :active_on, -> (date) { joins(:seats).merge(Seat.active_on(date)).distinct }

  mount_uploader :portrait, PortraitUploader, mount_on: :portrait_file

  def to_param
    self.slug_was
  end

  def seat
    @seat ||= seat_on(Date.current)
  end

  def seat_on(date)
    self.seats.active_on(date).take
  end

  def active_on?(date)
    self.seats.active_on(date).any?
  end

  def party
    seat.party
  end

  def party_on(date) # lol
    seat_on(date).party
  end

  def party_name
    self.party.present? ? self.party.name : ''
  end

  def local_electoral_area
    seat.local_electoral_area
  end

  def local_electoral_area_name
    self.local_electoral_area.present? ? self.local_electoral_area.name : ''
  end

  def attended?(meeting)
    self.attendances.attended.where(attendable: meeting).present?
  end

  def proposed_motions
    Motion.proposed_by(self)
  end

  def proposed_amendments
    Amendment.proposed_by(self)
  end

  def events # replace with scope on event so it's orderable
    self.seats.map(&:events).flatten
  end

  private

  def set_full_name
    self.full_name = "#{ self.given_name } #{ self.family_name }".strip
  end

  def set_given_and_family_names
    pcs = self.full_name.strip.split(' ')
    self.family_name = pcs.pop
    self.given_name = pcs.join(' ')
  end

  def generate_sort_name
    self.sort_name = "#{ self.family_name }, #{ self.given_name }"
  end

  def generate_slug
    return unless self.full_name

    self.slug = if self.class.where(slug: self.full_name.parameterize).
                              where.not(id: self.id).any?
      n = 1
      while self.class.where(slug: "#{ self.full_name.parameterize }-#{ n }").any?
        n += 1
      end
      "#{ self.full_name.parameterize }-#{ n }"
    else
      self.full_name.parameterize
    end
  end
end
