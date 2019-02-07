class HomeController < ApplicationController
  def show
    @motions = Motion.published
    @interesting_motions = @motions.where(interesting: true).by_occurred_on.limit(5)
    @parties = Party.by_name
    @local_electoral_areas = LocalElectoralArea.by_name

    @recent_meetings = Meeting.where(meeting_type: ['monthly', 'annual']).where(occurred_on: (Date.current - 1.year)..Date.current)

    @pct_present = Rails.cache.fetch("home/pct_present", expires_in: 1.hours) do
      if @recent_meetings.any?
        (@recent_meetings.map do |m|
          (m.attendances.attended.count * 100.0) / m.expected_attendance.count
        end.sum / @recent_meetings.count)
      else
        0
      end
    end

    @pct_absent = Rails.cache.fetch("home/pct_absent", expires_in: 1.hours) do
      if @recent_meetings.any?
        (@recent_meetings.map do |m|
          (m.attendances.where(status: 'absent').count * 100.0) / m.expected_attendance.count
        end.sum / @recent_meetings.count)
      else
        0
      end
    end
  end
end
