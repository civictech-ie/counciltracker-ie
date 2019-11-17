class AmendmentsController < ApplicationController
  def show
    @amendment = Amendment.find_by(hashed_id: params[:id])
    @motion = @amendment.motion
    @view = :votes
  end
end
