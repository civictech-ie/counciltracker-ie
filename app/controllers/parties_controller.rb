class PartiesController < ApplicationController
  def index
    @parties = current_council_session.parties.by_name
  end

  def show
    @party = Party.find_by(slug: params[:id])
    @view = params[:view].try(:to_sym) || :councillors
    @context = params[:context].try(:to_sym) || :full

    case @context
    when :full
      render action: :show
    when :partial
      render partial: "parties/#{ @view }", locals: {party: @party}
    else
      raise 'Unhandled render context'
    end
  end
end
