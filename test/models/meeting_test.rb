require 'test_helper'

class MeetingTest < ActiveSupport::TestCase

  test "scrapes meetings from DCC" do
    VCR.use_cassette 'dcc_meetings' do
      prev = Meeting.count
      MeetingScraperService.scrape_from_dcc!
      assert (Meeting.count == prev + 64)
    end
  end

  test "scrapes attendance from DCC" do
    VCR.use_cassette 'dcc_meeting_attendance' do
      MeetingScraperService.create_meeting_from_dcc_id!('2355', 'monthly')
      MeetingScraperService.create_meeting_from_dcc_id!('2430', 'monthly')
      tina = Councillor.find_by(slug: 'tina-macveigh')
      @meeting_1 = Meeting.find_by!(dcc_id: '2355')
      @meeting_2 = Meeting.find_by!(dcc_id: '2430')
      assert !tina.attended?(@meeting_1)
      assert tina.attended?(@meeting_2)
    end
  end

  test "scrapes 2324 successfully" do
    VCR.use_cassette 'dcc_problematic' do
      MeetingScraperService.create_meeting_from_dcc_id!('2324', 'monthly')
    end
  end
end
