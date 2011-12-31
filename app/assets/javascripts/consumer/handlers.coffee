
window.Events = {}
window.Events.refresh = (data)->
  window.map_view.center_point = data.center
  window.Filter.userFavorites = data.favorites
  window.filter.setValues()
  window.business_list.reset( data.businesses )
  window.event_list.reset( data.events )
  $( "#location_search" ).val( data.center.title.replace("\n",' ') )

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

  $( '.settings .link' ).live( 'click', (elem)->
    $( '.settings .filter' ).toggle('slide', {direction: 'left'})
  )

  $( '.location .link' ).live( 'click', (event)->
    $( '.location .search' ).toggle('slide', {direction: 'down'})
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

  ##################  oauth handlers ####################
  window.popupCenter = (url, width, height, name)->
    left = (screen.width/2)-(width/2)
    top = (screen.height/2)-(height/2)
    window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top)

  $("a.popup").live('click', (e)->
    window.popupCenter($(this).attr("href"), $(this).data('width'), $(this).data("height"), "authPopup")
    e.stopPropagation()
    return false
  )

  $("a.dialog").live('click', (event)->
    elem = $(event.currentTarget)
    event.stopPropagation()
    $('#auth_pop_up').load( elem.attr("href"), {_method: 'GET'}, ->
      $('#auth_pop_up').dialog({
        modal: true,
        title: elem.data("title"),
        resizable: false,
        width:'auto',
        height:'auto',
        closeOnEscape: true
      })
    )
    return false
  )

  window.closePopup = ->
    if(window.opener)
      window.opener.location.reload(true)
      window.close()

  $('form.new_user').live('submit', (e)->
    $.ajax({
      type: this.method,
      url: this.action,
      data: $(this).serialize(),
      success: -> $('#auth_pop_up').dialog('close'),
      error: (jqXHR, textStatus)-> $('#auth_pop_up').html(jqXHR.responseText)
    })
    return false
  )

  $('.facebook_login.link').live('click', (e)->
    $('.facebook_register').show()
  )
)