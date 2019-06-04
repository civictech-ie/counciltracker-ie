require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should validate_presence_of(:eventable) }
  it { should validate_presence_of(:occurred_on) }
end