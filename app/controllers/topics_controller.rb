class TopicsController < ApplicationController
  def index
    @topics = Motion.published.pluck(:tags).flatten.uniq.sort
  end

  def show
    @tag = params[:id].gsub("-"," ").capitalize
    @motions = Motion.published.in_category(@tag).includes(:meeting).page(params[:p])
  end
end
