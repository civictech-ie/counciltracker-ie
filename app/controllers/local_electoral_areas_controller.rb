class LocalElectoralAreasController < ApplicationController
  def index
    @local_electoral_areas = current_council_session.local_electoral_areas.by_name
  end

  def show
    @local_electoral_area = LocalElectoralArea.find_by(slug: params[:id])
    @view = params[:view].try(:to_sym) || :councillors
    @context = params[:context].try(:to_sym) || :full

    case @context
    when :full
      render action: :show
    when :partial
      render partial: "local_electoral_areas/#{@view}", locals: {local_electoral_area: @local_electoral_area}
    else
      raise "Unhandled render context"
    end
  end
end
