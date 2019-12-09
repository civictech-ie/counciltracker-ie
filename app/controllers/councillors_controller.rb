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
    @view = params[:view].try(:to_sym) || :votes
    @context = params[:context].try(:to_sym) || :full

    case @context
    when :full
      render action: :show
    when :partial
      render partial: "councillors/#{ @view }", locals: {councillor: @councillor}
    else
      raise 'Unhandled render context'
    end
  end
end
