$(document).ready(->

  return unless $('#wrapper.home')[0]

  ###############  login callbacks  ################
  $(".login form")
    .bind('ajax:beforeSend', (event, data)->
      form = $(this)
      form.find('.message').html('&nbsp;')
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

  ###############  registration callbacks ############
  $(".register form")
    .bind('ajax:beforeSend', (event, data)->
      form = $(this)
      form.find('.message').html('&nbsp;')
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
      errors = JSON.parse(status.responseText)
      messages = []
      for key, values of errors
        messages.push (key + ' ' + values.shift())
      form.find('.message').html(messages.join(', '))
    )

)
