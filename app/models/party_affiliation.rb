class PartyAffiliation < ApplicationRecord
  belongs_to :seat
  belongs_to :party

  validates :seat, presence: true
  validates :party, presence: true
end
