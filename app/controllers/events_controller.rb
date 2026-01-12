class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_event, only: [ :edit, :update ]

  def new
    @event = @group.events.build
  end

  def create
    @event = @group.events.build(event_params)
    @event.creator = current_user

    if @event.save
      redirect_to group_path(@group), notice: t("events.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to group_path(@group), notice: t("events.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_event
    @event = @group.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :public)
  end
end
