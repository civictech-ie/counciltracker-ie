class Admin::MotionsController < Admin::ApplicationController
  def show
    @motion = Motion.find_by(hashed_id: params[:id])
    @meeting = @motion.meeting
  end

  def new # nested under meetings
    @meeting = Meeting.find_by(hashed_id: params[:meeting_id])
    @motion = @meeting.motions.new(agenda_item: (((@meeting.motions.map(&:position).max || 0) / 100) + 1))
  end

  def create # nested under meetings
    @meeting = Meeting.find_by(hashed_id: params[:meeting_id])
    @motion = @meeting.motions.new(motion_params)
    if @motion.save
      redirect_to [:admin, @motion]
    else
      render :new
    end
  end

  def edit
    @motion = Motion.find_by(hashed_id: params[:id])
    @meeting = @motion.meeting
  end

  def publish
    @motion = Motion.find_by(hashed_id: params[:id])
    @meeting = @motion.meeting
    @motion.toggle_publication!
    redirect_to [:admin, @motion]
  end

  def update
    @motion = Motion.find_by(hashed_id: params[:id])
    @meeting = @motion.meeting
    if @motion.update(motion_params)
      redirect_to [:admin, @motion]
    else
      render :edit
    end
  end

  def votes
    @motion = Motion.find_by(hashed_id: params[:id])
    @meeting = @motion.meeting
  end

  def update_votes
    @motion = Motion.find_by(hashed_id: params[:id])
    @meeting = @motion.meeting
    if @motion.update(votes_params)
      render json: { saved_at: @motion.updated_at, message: "Saved at #{ Time.zone.now.strftime('%H:%M:%S') }" }
    else
      render json: { errors: @motion.errors.full_messages }
    end
  end

  private

  def motion_params
    params.require(:motion).permit(
      :executive_recommendation,
      :executive_vote,
      :body,
      :title,
      :votable,
      :pdf_url,
      :vote_ruleset,
      :vote_method,
      :vote_result,
      :agenda_item,
      :interesting,
      proposers_ids: [],
      local_electoral_area_ids: [],
      tags: []
    )
  end

  def votes_params
    params.require(:motion).permit(
      votes_attributes: [:id, :councillor_id, :status]
    )
  end
end
