$(document).ready(->

  return unless $('#wrapper.home')[0]

  ######  handle ajax login  ########
  $(".login form")
    .bind('ajax:beforeSend', (event, data)->
      form = $(this)
      form.find('#sign_in_button').prop("disabled", true)
      form.find('.spinner_elem').removeClass('invisible')
    )
    .bind('ajax:success', (event, data)->
      url = "/businesses/"
      if data.business
        url += data.business
      else
        url += 'new'
      window.location.href = url
    )
    .bind('ajax:complete', (event, data)->
      form = $(this)
      form.find('.spinner_elem').addClass('invisible')
      form.find('#sign_in_button').prop("disabled", false)
    )
    .bind('ajax:error', (xhr, status, error)->
      form = $(this)
      form.find('.message').html(status.responseText)
    )

  ######  handle registration  ########
  $(".register form")
    .bind('ajax:beforeSend', (event, data)->
      form = $(this)
      form.find('#register_button').prop("disabled", true)
      form.find('.spinner_elem').removeClass('invisible')
    )
    .bind('ajax:success', (event, data)->
      window.location.href = "/businesses/new"
    )
    .bind('ajax:complete', (event, data)->
      form = $(this)
      form.find('.spinner_elem').addClass('invisible')
      form.find('#register_button').prop("disabled", false)
    )
    .bind('ajax:error', (xhr, status, error)->
      form = $(this)
      form.find('.message').html(status.responseText)
    )

  #  $( '.sign_in' ).click( ->
  #    $('.home_opener').load( 'business_users/login', ->
  #      $('.home_opener').dialog(
  #          modal: true
  #          title: "Sign in"
  #          resizable: false
  #      )
  #    )
  #    return false
  #  )

)
