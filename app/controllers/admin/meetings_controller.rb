class Admin::MeetingsController < Admin::ApplicationController
  skip_before_action :verify_authenticity_token, only: [:save_attendance]

  def index
    @meetings = Meeting.by_occurred_on.page(params[:p])
  end

  def scrape
    MeetingScraperService.scrape_from_dcc!
    redirect_to [:admin, :meetings]
  end

  def show
    @meeting = Meeting.find_by!(hashed_id: params[:id])
    @view = params[:view].try(:to_sym) || :details
    @context = params[:context].try(:to_sym) || :full

    case @context
    when :full
      render action: :show
    when :partial
      render partial: "admin/meetings/#{ @view }", locals: {meeting: @meeting}
    else
      raise 'Unhandled render context'
    end
  end

  def new
    @meeting = Meeting.new(occurred_on: (Date.current - 1))
  end

  def create
    @meeting = Meeting.new(meeting_params)
    if @meeting.save
      redirect_to [:admin, @meeting]
    else
      render :new
    end
  end

  def edit
    @meeting = Meeting.find_by(hashed_id: params[:id])
  end

  def update
    @meeting = Meeting.find_by(hashed_id: params[:id])
    if @meeting.update(meeting_params)
      redirect_to [:admin, @meeting]
    else
      render :edit
    end
  end

  def save_attendance
    @meeting = Meeting.find_by(hashed_id: params[:id])
    @councillor = Councillor.find_by(id: params['councillorId'])
    @attendance = Attendance.find_or_initialize_by(attendable: @meeting, councillor: @councillor)
    @attendance.status = params['status']
    if @attendance.save
      render json: { saved_at: @attendance.updated_at, message: "Saved at #{ Time.zone.now.strftime('%H:%M:%S') }" }
    else
      render json: { errors: @attendance.errors.full_messages }
    end
  end

  private

  def meeting_params
    params.require(:meeting).permit(
      :meeting_type,
      :occurred_on
    )
  end
end
