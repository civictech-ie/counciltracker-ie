class TopicsController < ApplicationController
  def show
    @tag = params[:id].gsub("-"," ").capitalize
    @motions = Motion.published.in_category(@tag)
  end
end
