class PartiesController < ApplicationController
  def index
    @parties = current_council_session.parties.by_name
  end

  def show
    @party = current_council_session.parties.find_by(slug: params[:id])
    @councillors = @party.active_councillors
  end
end
