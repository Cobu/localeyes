
$(document).ready( ->

  $.ajaxSetup({
    headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}
  })

  $('.facebook_login.link').live('click', (e)->
    $('.facebook_register').show()
  )

  if $( "#location_search" )[0]
    $( "#location_search" ).autocomplete(
      source: '/consumers/search_location'
      select: ( event, ui ) ->
        $( "#location_search" ).val( ui.item.label )
        $.get('/consumers/events', {
              time: Date.now().toString('yyyy-MM-dd HH:mm'),
              zip_code: ui.item.zip_code,
              t: ui.item.type,
              d: ui.item.id }, (data)-> App.Controller.Events.refresh(data)
        )
        return false
    )


  if $( "#college_search" )[0]
    if $( '#content.home' ).data('logged_in')
      $( "#college_search" ).autocomplete(
        source: '/consumers/search_college'
        select: ( event, ui ) ->
          $( "#college_search" ).val( ui.item.label )
          window.location.href = "/event_list?college=#{ui.item.id}"
      )
    else
      $( "#college_search" ).autocomplete(
        source: (req,res)->
          $.get( '/consumers/search_college', {term: req.term}, (data)->
            $( ".no_college_found" ).toggle(_.isEmpty(data))
            $( '.no_college_found .notice' ).html('')
            $( '.college_found' ).hide()
            $( '.facebook_register' ).hide()
            res(data)
          )
        select: ( event, ui ) ->
          $( "#college_search" ).val( ui.item.label )
          $( '.college_found' ).show()
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
    $.post('/consumers/notify', {email: email, college: college}, ->
      $( '.notice' ).html("Done. When the college '#{college}' is available we will notify you at '#{email}'")
    )
  )

  ##################  viewing settings handlers #####################
  $( '.link_div .link' ).live( 'click', (event)->
    elem = $(event.currentTarget)
    type = elem.data('type')
    direction = elem.data('direction')
    elem.toggleClass('selected_link')
    $( ".#{type}" ).toggle('slide', {direction: direction})
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
    filter.setFavorite( elem.data('business_id') )
  )


  ################ voting handlers #############
  $('.images img[rel=vote]').live('click', (event)->
    elem = $(event.currentTarget)
    event_id = elem.data('id')
    vote = elem.data('vote')
    $.post('/users/event_vote',{ event:event_id, vote:vote }, (data)->
      # returns null if already voted .. TODO  might want to show a message for this case
      window.votes.resetVotes(data) if data
    )
  )

  ##################  sorting  handlers #####################
  $( '.sort_div .link' ).live( 'click', (event)->
    elem = $(event.currentTarget)
    type = elem.data('type')
    $('.sort_div .link').removeClass('selected_link')
    elem.addClass('selected_link')
    window.sorter.setSortType(type)
  )

  $('.event .info, .description').live('hover', ->
    $(this).closest('.event').toggleClass('hover')
  )

)