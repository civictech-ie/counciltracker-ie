class Admin::CouncillorsController < Admin::ApplicationController
  def index
    @councillors = Councillor.by_name
  end

  def show
    @councillor = Councillor.find_by(slug: params[:id])
  end

  def edit
    @councillor = Councillor.find_by(slug: params[:id])
  end

  def update
    @councillor = Councillor.find_by(slug: params[:id])
    if @councillor.update(councillor_params)
      redirect_to [:admin, @councillor]
    else
      render :show
    end
  end

  private

  def councillor_params
    params.require(:councillor).permit(
      :given_name,
      :family_name
    )
  end
end
