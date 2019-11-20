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
    @view = :votes
  end

  def votes
    @councillor = Councillor.find_by!(slug: params[:id])
    @view = :votes
    render :show
  end

  def motions
    @councillor = Councillor.find_by!(slug: params[:id])
    @view = :motions
    render :show
  end

  def amendments
    @councillor = Councillor.find_by!(slug: params[:id])
    @view = :amendments
    render :show
  end

  def attendances
    @councillor = Councillor.find_by!(slug: params[:id])
    @view = :attendances
    render :show
  end
end
