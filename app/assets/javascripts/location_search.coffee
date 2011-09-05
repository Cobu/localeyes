$(document).ready( ->
  return unless $( "#search_location" )[0]

  $( "#search_location" ).autocomplete(
    source: '/consumers/search_location'
    select: ( event, ui ) ->
      $( "#search_location" ).val( ui.item.zip_code )
      window.event_list.fetch({
        data: {zip_code: ui.item.zip_code},
        success: -> window.event_view.render()
      })
      return false
  )
  .data( "autocomplete" )._renderItem = ( ul, item ) ->
    return $( "<li></li>" )
      .data( "item.autocomplete", item )
      .append( "<a>" + item.city + ', ' + item.state_short + ', ' + item.zip_code + "</a>" )
      .appendTo( ul )
)
