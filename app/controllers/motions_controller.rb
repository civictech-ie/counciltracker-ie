class MotionsController < ApplicationController
  def index
    @motions = Motion.published.by_occurred_on.page(params[:p])

    respond_to do |format|
      format.html { render :index }
      format.json do
        @interesting_motions = @motions.where(interesting: true).by_occurred_on.limit(5)
        render json: @interesting_motions.limit(10)
      end
    end
  end

  def show
    @motion = Motion.published.find_by(hashed_id: params[:id])
    @view = :votes
    render :show
  end

  def votes
    @motion = Motion.published.find_by(hashed_id: params[:id])
    @view = :votes
    render :show
  end

  def amendments
    @motion = Motion.published.find_by(hashed_id: params[:id])
    @view = :amendments
    render :show
  end
end
