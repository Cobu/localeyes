class App.View.EventListView extends Backbone.View
  initialize: (@event_list)->
    @el = $('#event_list')
    if @event_list
      this.render()
    else
      @event_list = []
    @event_list.bind('reset', => @render())

  render: ->
    @el.empty()
    events = _(@event_list.models).groupBy((event)-> event.startDate())

    for num in [0..13]
      date = Date.today().addDays(num)
      days_events = _.select(events[date.toString("yyyy-MM-dd")], (event)-> window.filter.match(event.business()))
      continue unless _.any(days_events)
      this.buildEventsForDay(date, days_events)
    window.votes.show()


  buildEventsForDay: (date, events)->
    @el.append(new App.View.EventDayHeaderView('date': date).elem)
    _.each(events, (event)=>
        event_view = new App.View.EventView(model: event, date: date, logged_in: @event_list.logged_in)
        @el.append(event_view.elem)
    )
