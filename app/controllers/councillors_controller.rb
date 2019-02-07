class CouncillorsController < ApplicationController
  def index
    @local_electoral_areas = LocalElectoralArea.by_name
    @councillors = current_council_session.active_councillors.by_name
  end

  def show
    @councillor = current_council_session.councillors.find_by(slug: params[:id])
    @proposed_motions = @councillor.proposed_motions.published.by_occurred_on
    @proposed_amendments = @councillor.proposed_amendments.published.by_occurred_on
    @seat = @councillor.seat
    @attendances = @councillor.attendances.countable
    @votes = @councillor.votes.countable.sort_by(&:occurred_on).reverse
  end
end
