class CouncillorsController < ApplicationController
  def index
    @councillors = current_council_session.active_councillors.by_name.page(params[:p])

    respond_to do |f|
      f.html { render action: 'index' }
      f.json { render json: @councillors }
    end
  end

  def show
    @councillor = Councillor.find_by!(slug: params[:id])
    @proposed_motions = @councillor.proposed_motions.published.by_occurred_on.includes(:votes)
    @proposed_amendments = @councillor.proposed_amendments.published.by_occurred_on.includes(:votes)
    @seat = @councillor.seat
    @attendances = @councillor.attendances.countable.includes(:attendable)
    @votes = @councillor.votes.countable.sort_by(&:occurred_on).reverse
  end
end
