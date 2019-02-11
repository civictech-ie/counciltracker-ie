require 'rails_helper'

RSpec.describe Motion, type: :model do
  it { should validate_presence_of(:meeting) }
  it { should validate_presence_of(:agenda_item) }
  it { should validate_presence_of(:official_reference) }
  it { should validate_presence_of(:position) }
  it { should validate_presence_of(:vote_ruleset) }
  it { should validate_presence_of(:vote_method) }
  it { should validate_presence_of(:vote_result) }
end