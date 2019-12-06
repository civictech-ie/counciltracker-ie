class Admin::MotionsController < Admin::ApplicationController
  skip_before_action :verify_authenticity_token, only: [:save_vote]
  
  def show
    @motion = Motion.find_by(hashed_id: params[:id])
    @view = params[:view].try(:to_sym) || :details
    @context = params[:context].try(:to_sym) || :full

    case @context
    when :full
      render action: :show
    when :partial
      render partial: "admin/motions/#{ @view }", locals: {motion: @motion}
    else
      raise 'Unhandled render context'
    end
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

  def save_vote
    @motion = Motion.find_by(id: params[:id])
    @councillor = Councillor.find_by(id: params['councillorId'])
    @vote = Vote.find_or_initialize_by(voteable: @motion, councillor: @councillor)
    @vote.status = params['status']
    
    if @vote.save
      render json: { saved_at: @vote.updated_at, message: "Saved at #{ Time.zone.now.strftime('%H:%M:%S') }" }
    else
      render json: { errors: @vote.errors.full_messages }
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
      proposers_ids: [],
      local_electoral_area_ids: [],
      tags: []
    )
  end
end
