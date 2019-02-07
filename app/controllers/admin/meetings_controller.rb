class Admin::MeetingsController < Admin::ApplicationController
  def index
    @meetings = Meeting.by_occurred_on
  end

  def scrape
    MeetingScraperService.scrape_from_dcc!
    redirect_to [:admin, :meetings]
  end

  def show
    @meeting = Meeting.find_by(hashed_id: params[:id])
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

  def attendances
    @meeting = Meeting.find_by(hashed_id: params[:id])
  end

  def update_attendances
    @meeting = Meeting.find_by(hashed_id: params[:id])
    if @meeting.update(attendances_params)
      render json: { saved_at: @meeting.updated_at, message: "Saved at #{ Time.zone.now.strftime('%H:%M:%S') }" }
    else
      render json: { errors: @meeting.errors.full_messages }
    end
  end

  private

  def meeting_params
    params.require(:meeting).permit(
      :meeting_type,
      :occurred_on
    )
  end

  def attendances_params
    params.require(:meeting).permit(
      attendances_attributes: [:id, :councillor_id, :status]
    )
  end
end
