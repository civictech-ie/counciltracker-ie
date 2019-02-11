require 'rails_helper'

RSpec.describe CouncilSession, type: :model do
  it { should validate_presence_of(:commenced_on) }
end