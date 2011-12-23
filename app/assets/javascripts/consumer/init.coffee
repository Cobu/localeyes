$(document).ready( ->
  return unless $('#content.consumer_events')[0]

  window.business_list = new BusinessList([])
  window.event_list = new EventList([])
  window.map_view = new ExtendBoundMapView( business_list )
  window.event_list_view = new EventListView( event_list )
  window.filter.setValues()

  # if you are loading data while the page first shows
  data = $('#content.consumer_events').data('events')
  window.Events.refresh(data) if data and data.events
)

