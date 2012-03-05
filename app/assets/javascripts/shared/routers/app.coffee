class App.Router.Consumer extends Backbone.Router
  routes: '': 'event_list'

  event_list: ->
    window.consumer_events_view = new App.View.ConsumerEventsView()
    window.consumer_events_view.render()

    # if you are loading data while the page first shows
    data = $('#content.consumer_events').data('events')
    window.consumer_events_view.reset(data) if data and data.events
