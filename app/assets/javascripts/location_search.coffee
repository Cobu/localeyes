$(document).ready( ->
  return unless $( "#search_location" )[0]

  $( "#search_location" ).autocomplete(
    source: '/consumers/search_location'
    select: ( event, ui ) ->
      $( "#search_location" ).val( ui.item.label )
      $.get('/consumers/events', {
            time: Date.now().toString('yyyy-MM-dd HH:mm'),
            zip_code: ui.item.zip_code,
            t: ui.item.type,
            d: ui.item.id }, (data)->
              window.business_list = new window.BusinessList(data.businesses)
              window.event_list = new window.EventList(data.events)
              window.Filter.userFavorites = data.favorites
              window.filter.setValues()
              window.event_view.render()
              window.map_view.collection = business_list
              window.map_view.center_point = data.center
              window.map_view.render()
      )
      return false
  )


  $.get('/consumers/events',{time: Date.now().toString('yyyy-MM-dd HH:mm'),zip_code: 13126, t: 'z', d: 1}, (data)->
    window.business_list = new BusinessList(data.businesses)
    window.map_view = new ExtendBoundMapView(window.business_list)
    window.event_list = new EventList(data.events)
    window.Filter.userFavorites = data.favorites
    window.filter.setValues()
    window.event_view.render()
    window.map_view.center_point = data.center
    window.map_view.render()
  )

)
