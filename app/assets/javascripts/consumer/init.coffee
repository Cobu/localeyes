$(document).ready(->
    return unless $('#content.consumer_events')[0]

    window.event_list_container_view = new App.View.EventContainerView()

    # if you are loading data while the page first shows
    data = $('#content.consumer_events').data('events')
    window.event_list_container_view.refresh(data) if data and data.events
)

