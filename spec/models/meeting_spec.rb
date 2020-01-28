require "rails_helper"

RSpec.describe Meeting, type: :model do
  it { should validate_presence_of(:council_session) }
  it { should validate_presence_of(:meeting_type) }
  it { should validate_inclusion_of(:meeting_type).in_array(%w[monthly annual special budget finance]) }
  it { should validate_presence_of(:occurred_on) }
  it { should validate_uniqueness_of(:occurred_on).scoped_to(:meeting_type) }
end
