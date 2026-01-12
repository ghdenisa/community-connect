class TownSquareController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event
      .includes(:group, :creator)
      .public_events
      .ordered_by_start_desc
  end
end
