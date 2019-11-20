class PartiesController < ApplicationController
  def index
    @parties = current_council_session.parties.by_name
  end

  def show
    @party = Party.find_by(slug: params[:id])
    @view = :councillors

    respond_to do |f|
      f.html { render action: 'show' }
      f.json { render json: @party }
    end
  end

  def councillors
    @party = Party.find_by(slug: params[:id])
    @view = :councillors
    render :show
  end
end
