class UserSessionsController < ApplicationController
  # skip_before_action :require_login, except: [:destroy]
  layout "admin"

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email_address], params[:password])
      redirect_to [:admin, :root]
    else
      flash.now[:alert] = "Login failed"
      render action: "new"
    end
  end

  def destroy
    logout
    redirect_to :root, notice: "Logged out!"
  end
end
