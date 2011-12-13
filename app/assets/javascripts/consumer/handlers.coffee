$(document).ready( ->

  if $( "#location_search" )[0]
    $( "#location_search" ).autocomplete(
      source: '/consumers/search_location'
      select: ( event, ui ) ->
        $( "#location_search" ).val( ui.item.label )
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

  if $( "#college_search" )[0]
    $( "#college_search" ).autocomplete(
      source: (req,res)->
        $.get( '/consumers/search_college', {term: req.term}, (data)->
          $( ".no_college_found" ).toggle(_.isEmpty(data))
          res(data)
        )
      select: ( event, ui ) ->
        $( "#college_search" ).val( ui.item.label )

    )

  $( '#notify_me' ).live( 'click', ->
     email = $( '#notify_email' ).val()
     college = $( '#college_search' ).val()
     console.log( [email, college] )
#    $.post('/consumers/notify', {email: email, college: college}, (data)->
#
#    )
  )
)