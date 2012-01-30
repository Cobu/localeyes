$(document).ready(->
    return unless $('#content.consumer_events')[0]
    window.business_list = new App.Collection.BusinessList([])
    window.event_list = new App.Collection.EventList([])
    window.map_view = new App.View.ExtendBoundMapView(business_list)
    window.event_list_view = new App.View.EventListView(event_list)
    window.filter.setValues()

    # if you are loading data while the page first shows
    data = $('#content.consumer_events').data('events')
    App.Controller.Events.refresh(data) if data and data.events

    $('.legend').toggle('slide', {direction: 'down'})
    $('.search').toggle('slide', {direction: 'down'})
    $('.filter').toggle('slide', {direction: 'left'})
)

