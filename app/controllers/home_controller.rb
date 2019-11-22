class HomeController < ApplicationController
  def show
    @council_session = CouncilSession.current_on(Date.current).take
    @local_electoral_areas = @council_session.local_electoral_areas.by_name
    @parties = @council_session.parties.by_name
    @topics = Motion.published.pluck(:tags).flatten.uniq.sort
  end
end
