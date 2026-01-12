class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = Group.all.order(name: :asc)
  end
end
