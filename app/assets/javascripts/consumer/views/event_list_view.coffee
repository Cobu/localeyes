class App.View.EventListView extends Backbone.View

  initialize: (options)->
    @container_view = options.event_container_view
    @el = $('#event_list')
    @collection.bind('reset', => @render())
    @container_view.filter.bind('change:service_types', => @render())
    @render() if @collection

  render: ->
    @el.empty()
    events = _(@collection.models).groupBy((event)-> event.startDate())

    for num in [0..13]
      date = Date.today().addDays(num)
      days_events =
        _.select(events[date.toString("yyyy-MM-dd")],
          (event)=>
            @container_view.filter.match(event.business())
        )
      continue unless _.any(days_events)
      this.buildEventsForDay(date, days_events)
    @container_view.votes.show()


  buildEventsForDay: (date, events)->
    @el.append(new App.View.EventDayHeaderView('date': date).elem)
    _.each(events, (event)=>
        event_view =
          new App.View.EventView(model: event, date: date, event_container_view: @container_view)
        @el.append(event_view.elem)
    )
