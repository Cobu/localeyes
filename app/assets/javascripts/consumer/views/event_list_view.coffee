class App.View.EventListView extends Backbone.View
  className: 'event_list_container'

  initialize: (options)->
    @container_view = options.consumer_events_view
    @collection.bind('reset', => @renderEvents() )
    @container_view.filter.bind('change:service_types', 'render' )
    @header = new App.View.EventListHeaderView(consumer_events_view: @container_view)
    @outer_elem = $('<div class="event_list_inner"></div>')
    @inner_elem = $('<div class="event_list"></div>')
    @outer_elem.append( @inner_elem )

  render: ->
    $(@el).append( @outer_elem )
    @inner_elem.append( @header.render().el )
    @renderEvents() if @collection
    this

  renderEvents: =>
    events = @collection.groupBy((event)-> event.startDate())
    for num in [0..13]
      date = Date.today().addDays(num)
      days_events =
        _.select(events[date.toString("yyyy-MM-dd")],
          (event)=> @container_view.filter.match( event.business() )
        )
      continue unless _.any(days_events)
      @buildEventsForDay(date, days_events)
    @container_view.votes.show()

  buildEventsForDay: (date, events)->
    $(@inner_elem).append( new App.View.EventDayHeaderView('date': date).render().el )
    _.each(events, (event)=>
        event_view =
          new App.View.EventView(model: event, date: date, consumer_events_view: @container_view)
        $(@inner_elem).append( event_view.render().el )
    )
