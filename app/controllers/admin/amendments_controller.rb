class Admin::AmendmentsController < Admin::ApplicationController
  def show
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @motion = @amendment.motion
    @meeting = @motion.meeting
  end

  def new # nested under motions
    @motion = Motion.find_by(hashed_id: params[:motion_id])
    @meeting = @motion.meeting
    @amendment = @motion.amendments.new
  end

  def create # nested under motions
    @motion = Motion.find_by(hashed_id: params[:motion_id])
    @meeting = @motion.meeting
    @amendment = @motion.amendments.new(amendment_params)
    if @amendment.save
      redirect_to [:admin, @amendment]
    else
      render :new
    end
  end

  def edit
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @motion = @amendment.motion
    @meeting = @motion.meeting
  end

  def update
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @motion = @amendment.motion
    @meeting = @motion.meeting

    if @amendment.update(amendment_params)
      redirect_to [:admin, @amendment]
    else
      render :edit
    end
  end

  def votes
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @motion = @amendment.motion
    @meeting = @motion.meeting
  end

  def update_votes
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @motion = @amendment.motion
    @meeting = @motion.meeting
    bv = @amendment.votes.countable.count
    if @amendment.update(votes_params)
      render json: { saved_at: @amendment.updated_at, message: "Saved at #{ Time.zone.now.strftime('%H:%M:%S') }" }
    else
      render json: { errors: @amendment.errors.full_messages }
    end
  end

  private

  def amendment_params
    params.require(:amendment).permit(
      :body,
      :vote_ruleset,
      :vote_method,
      :vote_result,
      :position,
      proposers_ids: []
    )
  end

  def votes_params
    params.require(:amendment).permit(
      votes_attributes: [:id, :councillor_id, :status]
    )
  end
end
