class MotionsController < ApplicationController
  def index
    @council_session = current_council_session
    @motions = @council_session.motions.published.order('motions.updated_at desc')

    respond_to do |format|
      format.html { render :index }
      format.json do
        @interesting_motions = @motions.where(interesting: true).by_occurred_on.limit(5)
        render json: @interesting_motions.limit(10)
      end
    end
  end

  def show
    @council_session = current_council_session
    @motion = @council_session.motions.published.find_by(hashed_id: params[:id])
  end
end
