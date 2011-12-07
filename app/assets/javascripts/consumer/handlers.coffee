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
              window.map_view.center_point = data.center
              window.business_list.reset( data.businesses )
              window.event_list.reset( data.events )
              window.Filter.userFavorites = data.favorites
              window.filter.setValues()
      )
      return false
  )
)
