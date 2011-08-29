window.CalendarOptions = {
  mode :  'liquid',
  header : {
    left: 'prev,next today',
    center: 'title',
    right: 'month,agendaWeek'
  },
  events_url : '/events'
}

$(document).ready( ->

  # check the ending recur date and set message if blank
  $('#event_recur_until_date').live('change', ->
    if $(this).val() == "" or $(this).val() == null
      $(this).val("")
      $(this).addClass("message")
    else
     $(this).removeClass("message")
  ).trigger('change')


  window.toggleEditUntilDate = ()->
    once_selected = $('input[name="event[recur_value]"]:checked').val() == "once"

    $('#event_recur_until_date').prop('disabled',once_selected)

    if once_selected
      $('#event_recur_until_date').val('')
      $('label[for=event_recur_until_date]').addClass('disabled_text')
    else
      $('label[for=event_recur_until_date]').removeClass('disabled_text')

    $('.edit_event').live('ajax:success', (data, status, xhr) ->
       $('.affecting').dialog('close')
       $('#event_pop_up').dialog('close')
       $('#calendar_container').fullCalendar('refetchEvents')
    )

  # set the type of edit_effects and submit the form
  $( "#edit_affects_one, #edit_affects_all_series").live( "click", ->
    $('#edit_affects_type').val($('input[name=edit_affects]:checked').val())
    $('form').submit()
  )

  # the cancel button closes dialog
  $( "#edit_affects_cancel").live('click', ()->
    $('.affecting').dialog('close')
  )

  # on submit, change the action to a delete or a put(update)
  $('form.edit_event input[type=submit]').live('click', (event)->
    method = $(this).data('method')
    $(this).closest('form').find('#_method').val(method)

    # if edit, you can only edit the series
    if method == 'put'
      $('label[for=edit_affects_one]').hide()
      $('#edit_affects_one').prop('disabled',true)
    else # if delete, you can edit one, or the whole series
      $('label[for=edit_affects_one]').show()
      $('#edit_affects_one').prop('disabled',false)

    # confirm the type of edit to a recurring event
    recur_value = $('input[name="event[recur_value]"]:checked').val()
    if (recur_value != "once")
      edit_type = if method == 'put' then 'Edit' else 'Delete'
      $('.affecting .text').html("This #{edit_type} will affect:")
      $('.affecting').dialog(
        modal:true
        title: "Confirm #{edit_type}"
        resizable: false
        closeOnEscape: false
        close: -> $('#affecting').dialog('destroy')
      )
      return false
  )


  # if its not a recurring event hide the end date setting
  $('input[name="event[recur_value]"]').live('change', window.toggleEditUntilDate )

  $('.new_event').live('ajax:success', (data, status, xhr) ->
     $('#event_pop_up').dialog('close')
     $('#calendar_container').fullCalendar('refetchEvents')
  )
)