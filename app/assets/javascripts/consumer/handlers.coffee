$(document).ready( ->

  $.ajaxSetup({
    headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}
  })

  $('.facebook_login.link').live('click', (e)->
    $('.facebook_register').show()
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

)