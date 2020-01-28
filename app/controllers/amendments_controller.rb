class AmendmentsController < ApplicationController
  def show
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @view = params[:view].try(:to_sym) || :votes
    @context = params[:context].try(:to_sym) || :full

    case @context
    when :full
      render action: :show
    when :partial
      render partial: "amendments/#{@view}", locals: {amendment: @amendment}
    else
      raise "Unhandled render context"
    end
  end
end
