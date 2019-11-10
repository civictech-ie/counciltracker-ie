class MeetingsController < ApplicationController
  def index
    @meetings = Meeting.has_countable_attendances.order('occurred_on desc').page(params[:p])
  end

  def show
    @meeting = Meeting.where(meeting_type: params[:meeting_type], occurred_on: params[:occurred_on]).take
    @view = :motions
  end

  def motions
    @meeting = Meeting.find_by(hashed_id: params[:id])
    @view = :motions
    render :show
  end

  def attendance
    @meeting = Meeting.find_by(hashed_id: params[:id])
    @view = :attendance
    render :show
  end
end
