#$(document).ready( ->
#
#  $.get('/consumers/events',{time: Date.now().toString('yyyy-MM-dd HH:mm'),zip_code: 13126, t: 'z', d: 1}, (data)->
#    window.business_list = new BusinessList(data.businesses)
#    window.map_view = new ExtendBoundMapView(window.business_list)
#    window.event_list = new EventList(data.events)
#    window.event_list_view = new EventListView(window.event_list)
#    window.event_list_view.el = $( 'ul.ui-listview' )
#    window.Filter.userFavorites = data.favorites
#    window.filter.setValues()
#    window.event_list_view.render()
#    window.map_view.center_point = data.center
#    window.map_view.render()
#  )
#
#)
#
#
