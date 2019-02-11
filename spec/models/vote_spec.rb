require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of(:councillor) }
  it { should validate_presence_of(:voteable) }
  it { should validate_presence_of(:status) }
end