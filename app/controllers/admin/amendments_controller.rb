class Admin::AmendmentsController < Admin::ApplicationController
  skip_before_action :verify_authenticity_token, only: [:save_vote]
  
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
  
  def show
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @view = params[:view].try(:to_sym) || :details
    @context = params[:context].try(:to_sym) || :full

    case @context
    when :full
      render action: :show
    when :partial
      render partial: "admin/amendments/#{ @view }", locals: {amendment: @amendment}
    else
      raise 'Unhandled render context'
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

  def destroy
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @motion = @amendment.motion
    @amendment.destroy!
    redirect_to [:admin, @motion]
  end

  def save_vote
    @amendment = Amendment.find_by(id: params[:id])
    @councillor = Councillor.find_by(id: params['councillorId'])
    @vote = Vote.find_or_initialize_by(voteable: @amendment, councillor: @councillor)
    @vote.status = params['status']
    
    if @vote.save
      render json: { saved_at: @vote.updated_at, message: "Saved at #{ Time.zone.now.strftime('%H:%M:%S') }" }
    else
      render json: { errors: @vote.errors.full_messages }
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
end
