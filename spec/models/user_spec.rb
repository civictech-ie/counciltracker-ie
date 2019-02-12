require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_uniqueness_of(:email_address) }
  it { should validate_presence_of(:email_address) }
  it { should validate_presence_of(:password) }
end