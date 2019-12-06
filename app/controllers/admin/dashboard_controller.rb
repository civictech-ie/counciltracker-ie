class Admin::DashboardController < Admin::ApplicationController
  def show
    redirect_to [:admin, :meetings]
  end
end
