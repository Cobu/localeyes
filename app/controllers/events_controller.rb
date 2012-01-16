class EventsController < ApplicationController
  before_filter :find_event, :only => [:show, :edit, :update]

  def show
  end

  def new
    @event = current_business.events.new(start_time: params[:start_time], end_time: params[:end_time])
    @event = EventDecorator.new(@event)
    render :edit, :layout => "events"
  end

  def edit
    render :layout=> 'events'
  end

  def create
    current_business.events.create(params[:event])
    head :ok
  end

  def update
    case params[:edit_affects_type]
      when 'all_series','' then
        @event.update_attributes(params[:event])
      when 'one' then
        start_time = Time.zone.parse(params[:edit_start_time])
        # add exception rule
        @event.schedule.add_exception_date(start_time)

        new_event = Event.new(@event.attributes.except(:id).merge(params[:event]))
        new_event.start_time = start_time
        end_time = @event.end_time.advance(:days => (start_time.to_date - @event.start_time.to_date).to_i + params[:start_end_date_diff].to_i)
        new_event.end_time = end_time

        Event.transaction do
          new_event.save
          @event.save
        end
    end
    head :ok
  end

  def destroy
    @event = current_business.events.find_by_id(params[:id])
    case  params[:edit_affects_type]
      when 'all_series', '' then
        @event.destroy
      when 'one' then
        start_time = Time.zone.parse(params[:edit_start_time])
        # add exception rule
        @event.add_exception_date(start_time)
        @event.save
    end
    head :ok
  end

  private

  def find_event
    @event = EventDecorator.new( current_business.events.find_by_id(params[:id]) )
  end
end