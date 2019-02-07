class UsersController < ApplicationController
  # skip_before_action :require_login, only: [:new, :create]
  layout 'modal'

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to [:admin, :root]
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password)
  end
end
