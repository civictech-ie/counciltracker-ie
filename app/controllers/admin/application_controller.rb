class Admin::ApplicationController < ApplicationController
  before_action :require_login
  layout 'admin'
end
