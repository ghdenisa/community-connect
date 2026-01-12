class TownSquareController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event
      .includes(:group, :creator)
      .public_events
      .by_start_date
  end
end
