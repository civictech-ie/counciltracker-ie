class LocalElectoralArea < ApplicationRecord
  has_many :seats
  has_many :active_seats, -> { active }, class_name: 'Seat'

  has_many :councillors, -> { distinct }, through: :seats
  has_many :local_electoral_areas, -> { distinct }, through: :seats
  has_many :active_councillors, -> { distinct }, source: :councillor, through: :active_seats

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug

  scope :by_name, -> { order('name asc') }

  def to_param
    self.slug
  end

  def motions
    Motion.related_to_area(self)
  end

  private

  def generate_slug
    return unless self.name
    self.slug = self.name.parameterize
  end
end
