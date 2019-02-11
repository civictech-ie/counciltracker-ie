require 'rails_helper'

RSpec.describe CoOption, type: :model do
  it { should validate_presence_of(:outgoing_seat) }
  it { should validate_presence_of(:incoming_councillor) }
  it { should validate_presence_of(:incoming_party) }
end