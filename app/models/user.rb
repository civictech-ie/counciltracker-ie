class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :email_address, presence: true, uniqueness: true
  validates_presence_of :password, on: :create

  def is_admin?
    admin
  end
end
