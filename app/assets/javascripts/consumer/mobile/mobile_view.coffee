#
#$(document).ready( ->
#  window.business_list = new BusinessList([])
#  window.event_list = new EventList([])
#  window.map_view = new ExtendBoundMapView(business_list)
#  window.event_list_view = new EventListView(event_list)
#  window.filter.setValues()
#
#  data = $('#content.consumer_events').data('events')
#  window.Events.refresh(data) if data and data.events
#  $('ul').listview('refresh')
#)
#
#
#$('[data-role=page]').live('pageshow', (event) ->
#  if event.target.id == 'map_page'
#    window.map_view.reRender() if window.map_view
#)
#
#
###################  filter handlers #####################
#$('label[for^=checkbox]').live('click', (event)->
#  elem = $(event.currentTarget)
#  console.log elem.data('service_type'), elem.prev('input').prop('checked')
#  filter.setServiceType( elem.data('service_type'), elem.prev('input').prop('checked') )
#)
#
#
#
