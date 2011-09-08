$(document).ready( ->
  return unless $( "#search_location" )[0]

  $( "#search_location" ).autocomplete(
    source: '/consumers/search_location'
    select: ( event, ui ) ->
      $( "#search_location" ).val( ui.item.zip_code )
      $.get('/consumers/events',{time: Date.now().toString('yyyy-MM-dd HH:mm'), zip_code: ui.item.zip_code}, (data)->
        window.business_list = new window.BusinessList(data.businesses)
        window.event_list = new window.EventList(data.events)
        window.filter.userFavorites = data.favorites
        window.event_view.render()
        window.map_view.render()
      )
  )
  .data( "autocomplete" )._renderItem = ( ul, item ) ->
    return $( "<li></li>" )
      .data( "item.autocomplete", item )
      .append( "<a>" + item.city + ', ' + item.state_short + ', ' + item.zip_code + "</a>" )
      .appendTo( ul )


  $.get('/consumers/events',{time: Date.now().toString('yyyy-MM-dd HH:mm'),zip_code: 13126}, (data)->
    window.business_list = new BusinessList(data.businesses)
    window.event_list = new EventList(data.events)
    window.filter.userFavorites = data.favorites
    event_view.render()
    map_view.render()
  )

)
