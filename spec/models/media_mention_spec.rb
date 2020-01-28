require "rails_helper"

RSpec.describe MediaMention, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:mentionable) }
end
