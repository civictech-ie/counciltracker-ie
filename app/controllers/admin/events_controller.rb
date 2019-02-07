class Admin::EventsController < Admin::ApplicationController
  def index
    @events = Event.by_occurred_on
  end

  def show
    @event = Event.find(params[:id])
  end
end
