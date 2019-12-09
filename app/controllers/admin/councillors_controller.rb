class Admin::CouncillorsController < Admin::ApplicationController
  def index
    @councillors = Councillor.by_name.page(params[:p])
  end

  def show
    @councillor = Councillor.find_by(slug: params[:id])
  end
end