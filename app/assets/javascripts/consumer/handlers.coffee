
window.Events = {}
window.Events.refresh = (data)->
  window.map_view.center_point = data.center
  window.business_list.reset( data.businesses )
  window.event_list.reset( data.events )
  window.Filter.userFavorites = data.favorites
  window.filter.setValues()
  $( "#location_search" ).val(data.center.title)

$(document).ready( ->

  $.ajaxSetup({
    headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}
  })

  if $( "#location_search" )[0]
    $( "#location_search" ).autocomplete(
      source: '/consumers/search_location'
      select: ( event, ui ) ->
        $( "#location_search" ).val( ui.item.label )
        $.get('/consumers/events', {
              time: Date.now().toString('yyyy-MM-dd HH:mm'),
              zip_code: ui.item.zip_code,
              t: ui.item.type,
              d: ui.item.id }, (data)-> Events.refresh(data)
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
        # register the college picked
        $.ajax(
          url: '/users/register_college',
          type: 'post',
          data: {college: ui.item.label},
          success: (response)-> $( '.college_found' ).show(),
          error: (response)-> alert('The college selected is not valid')
        )
    )

  $( '#notify_me' ).live( 'click', ->
    email = $( '#notify_email' ).val()
    college = $( '#college_search' ).val()
    console.log( [email, college] )
    $.post('/consumers/notify', {email: email, college: college} )
  )

  $( '.settings .link' ).live( 'click', (elem)->
    $( '.settings .filter' ).toggle('slide', {direction: 'up'})
  )

  $( '.location .link' ).live( 'click', (event)->
    $( '.location .search' ).toggle('slide', {direction: 'left'})
  )

 $( '.event_types .link' ).live( 'click', (event)->
    $( '.event_types .legend' ).toggle('slide', {direction: 'down'})
  )


  ##################  filter handlers #####################
  $('.filter input[name^=service_type]').live('click', (event)->
    elem = $(event.currentTarget)
    filter.setServiceType( elem.attr('id'), elem.prop('checked') )
  )

  $('input[name=filtering_favorites]').live('click', (event)->
    elem = $(event.currentTarget)
    filter.setFilteringByFavorites( elem.prop('checked') )
  )

  $('.images img[rel=favorite]').live('click', (event)->
    elem = $(event.currentTarget)
    filter.setFavorite( elem.data('busniess_id') )
  )

)