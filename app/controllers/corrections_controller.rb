class CorrectionsController < ApplicationController
  def new
    @correction = Correction.new
  end

  def create
    @correction = Correction.new(correction_params)
    if @correction.save
      redirect_to [:thanks, :corrections]
    else
      render :new
    end
  end

  def thanks
  end

  private

  def correction_params
    params.require(:correction).permit(
      :name,
      :email_address,
      :body
    )
  end
end
