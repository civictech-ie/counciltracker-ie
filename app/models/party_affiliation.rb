class PartyAffiliation < ApplicationRecord
  belongs_to :seat
  belongs_to :party

  validates :seat, presence: true, uniqueness: [:party, :commenced_on]
  validates :party, presence: true
end
