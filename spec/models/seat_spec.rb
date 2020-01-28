require "rails_helper"

RSpec.describe Seat, type: :model do
  it { should validate_presence_of(:council_session) }
  it { should validate_presence_of(:local_electoral_area) }
  it { should validate_presence_of(:councillor) }
end
