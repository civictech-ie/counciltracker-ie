require "rails_helper"

RSpec.describe Councillor, type: :model do
  it { should validate_presence_of(:full_name) }
end
