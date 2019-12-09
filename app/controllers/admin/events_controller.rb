class Admin::EventsController < Admin::ApplicationController
  def index
    @events = Event.by_occurred_on.page(params[:p])
  end

  def show
    @event = Event.find(params[:id])
  end
end
