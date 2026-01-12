class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = Group.all.order(name: :asc)
  end

  def show
    @group = Group.find(params[:id])
    @events = @group.events.ordered_by_start_desc
  end
end
