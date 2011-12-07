$(document).ready( ->

  window.business_list = new BusinessList([])
  business_list.bind('reset', -> business_list.clearMarkers() )
  window.event_list = new EventList([])
  window.map_view = new ExtendBoundMapView( business_list )
  window.event_list_view = new EventListView( event_list )
  window.filter.setValues()

)

