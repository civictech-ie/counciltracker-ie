class PartyAffiliation < ApplicationRecord
  belongs_to :seat
  belongs_to :party
end
