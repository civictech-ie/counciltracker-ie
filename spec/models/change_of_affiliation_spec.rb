require 'rails_helper'

RSpec.describe ChangeOfAffiliation, type: :model do
  it { should validate_presence_of(:occurred_on) }
  it { should validate_presence_of(:councillor) }
  it { should validate_presence_of(:outgoing_party) }
  it { should validate_presence_of(:incoming_party) }
end
