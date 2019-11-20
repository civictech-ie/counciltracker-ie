class HomeController < ApplicationController
  def show
    @interesting_motions = Motion.published.where(interesting: true).by_occurred_on.limit(10)
    @council_session = CouncilSession.current_on(Date.current).take
    @parties = @council_session.parties.by_name
  end
end
