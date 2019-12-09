class Correction < ApplicationRecord
  validates :body, presence: true
  validates :name, presence: true
  validates :email_address, presence: true

  paginates_per 20
end
