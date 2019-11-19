class Party < ApplicationRecord
  has_many :party_affiliations
  has_many :seats, -> { distinct }, through: :party_affiliations

  has_many :councillors, -> { distinct }, through: :seats
  has_many :local_electoral_areas, -> { distinct }, through: :seats

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug

  scope :by_name, -> { order('name asc') }

  def to_param
    self.slug
  end

  def active_councillors
    self.councillors.active_on(Date.today)
  end

  private

  def generate_slug
    return unless self.name
    self.slug = self.name.parameterize
  end
end
