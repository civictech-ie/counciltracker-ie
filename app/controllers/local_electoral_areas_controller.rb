class LocalElectoralAreasController < ApplicationController
  def index
    @local_electoral_areas = current_council_session.local_electoral_areas.by_name
  end

  def show
    @local_electoral_area = current_council_session.local_electoral_areas.find_by(slug: params[:id])
    @councillors = @local_electoral_area.councillors
    @motions = @local_electoral_area.motions.published
  end
end
