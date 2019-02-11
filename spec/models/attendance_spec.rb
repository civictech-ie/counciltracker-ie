require 'rails_helper'

RSpec.describe Attendance, type: :model do
  it { should validate_presence_of(:councillor) }
  it { should validate_presence_of(:status) }
end
