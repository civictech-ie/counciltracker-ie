class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :email_address, uniqueness: true, presence: true
  validates_presence_of :password, on: :create

  def is_admin?
    admin
  end
end
