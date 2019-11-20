class LocalElectoralAreasController < ApplicationController
  def index
    @local_electoral_areas = current_council_session.local_electoral_areas.by_name
  end

  def show
    @local_electoral_area = LocalElectoralArea.find_by(slug: params[:id])
    @view = :councillors

    respond_to do |f|
      f.html { render action: 'show' }
      f.json { render json: @local_electoral_area }
    end
  end

  def councillors
    @local_electoral_area = LocalElectoralArea.find_by(slug: params[:id])
    @view = :councillors
    render :show
  end

  def motions
    @local_electoral_area = LocalElectoralArea.find_by(slug: params[:id])
    @view = :motions
    render :show
  end
end
