$(document).ready(->
    return unless $('#content.consumer_events')[0]

    window.consumer_events_view = new App.View.ConsumerEventsView()
    window.consumer_events_view.render()

    # if you are loading data while the page first shows
    data = $('#content.consumer_events').data('events')
    window.consumer_events_view.refresh(data) if data and data.events
)

