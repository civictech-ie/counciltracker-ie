class TopicsController < ApplicationController
  def index
    @topics = Motion.published.pluck(:tags).flatten.uniq.sort
  end

  def show
    @tag = params[:id].tr("-", " ").capitalize
    @motions = Motion.published.in_category(@tag).includes(:meeting).page(params[:p])
    @view = params[:view].try(:to_sym) || :motions
    @context = params[:context].try(:to_sym) || :full

    case @context
    when :full
      render action: :show
    when :partial
      render partial: "topics/#{@view}", locals: {motions: @motions}
    else
      raise "Unhandled render context"
    end
  end
end
