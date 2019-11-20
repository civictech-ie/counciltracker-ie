class AmendmentsController < ApplicationController
  def show
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @view = :votes
  end
end
