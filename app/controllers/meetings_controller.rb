class MeetingsController < ApplicationController
  def index
    @council_session = CouncilSession.current
    @meetings = @council_session.meetings.has_countable_attendances.order('occurred_on desc')
  end

  def show
    @council_session = CouncilSession.current
    @meeting = Meeting.where(meeting_type: params[:meeting_type], occurred_on: params[:occurred_on]).take
    @motions = @meeting.motions.published.by_position
    @attendances = @meeting.attendances.countable.by_status
  end
end
