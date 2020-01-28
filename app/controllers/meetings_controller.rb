class MeetingsController < ApplicationController
  def index
    @meetings = Meeting.has_published_motions.by_occurred_on.page(params[:p])
  end

  def show
    @meeting = Meeting.find_by!(meeting_type: params[:meeting_type], occurred_on: params[:occurred_on])
    @view = params[:view].try(:to_sym) || :motions
    @context = params[:context].try(:to_sym) || :full

    case @context
    when :full
      render action: :show
    when :partial
      render partial: "meetings/#{@view}", locals: {meeting: @meeting}
    else
      raise "Unhandled render context"
    end
  end
end
