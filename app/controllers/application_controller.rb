class ApplicationController < ActionController::Base
  before_action :redirect_domain, if: -> { Rails.env.production? && ENV['APP_DOMAIN'] }
  protect_from_forgery with: :exception

  def current_account
    return nil unless logged_in?
    current_user.account
  end

  def current_council_session
    @council_session ||= CouncilSession.latest
  end
  helper_method :current_council_session

  private

  def not_authenticated
    redirect_to signin_path, alert: "You need to log in."
  end

  def redirect_domain
    return true if request.host == ENV['APP_DOMAIN']
    redirect_to [request.protocol,ENV['APP_DOMAIN'],request.fullpath].join, status: :moved_permanently
  end
end
