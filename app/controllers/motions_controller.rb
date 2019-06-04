class MotionsController < ApplicationController
  def index
    @motions = Motion.published.order('motions.updated_at desc')

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
    @council_session = @motion.council_session
  end
end
