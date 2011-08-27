class EventsController < ApplicationController

  def index
    start_date = Time.at(params[:start].to_i).to_date
    end_date = Time.at(params[:end].to_i).to_date
    events = current_business.events.all
    details = events.collect { |e| e.occurrences_between(start_date, end_date) }.flatten
    render :json=> details
  end

  def show
    @event = current_business.events.find(params[:id])
  end

  def new
    @event = current_business.events.new(:start_time=>params[:start_time],:end_time=>params[:end_time])
    render :edit, :layout => "events"
  end

  def edit
    @event = current_business.events.find(params[:id])
    render :layout=> 'events'
  end

  def create
    e = current_business.events.new(params[:event])
    e.save
    head :ok
  end

  def update
    @event = current_business.events.find(params[:id])

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
    @event = current_business.events.find(params[:id])

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

end