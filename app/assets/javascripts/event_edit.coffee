$(document).ready( ->

  # hide this affecting dialog to start
  $('.affecting').hide()

  #set up date picker and button sets
  $('#event_start_date').datepicker({ minDate: new Date() })
  $('#event_end_date').datepicker({ minDate: new Date() })
  $('#event_recur_until_date').datepicker({ minDate: new Date() })
  $(".event_type_radio, .recurrence_radio, .choices_radio" ).buttonset()

  ######### edit events ################
  if $('.edit_event')[0]

    window.toggleEditUntilDate()

    # set the start/end date
    start_time = Date.parse($('#edit_start_time').val())
    $('#event_start_date').val(start_time.toString('MM/dd/yyyy'))

    end_time = start_time.addDays($('#start_end_date_diff').val())
    $('#event_end_date').val(end_time.toString('MM/dd/yyyy'))

    # for any edit event, can't change the recur type
    $('.recurrence_radio').buttonset('disable')
    # for recurring events can't chance the date/time
    recur_value = $('input[name="event[recur_value]"]:checked').val()
    if (recur_value != "once")
      $('.time_field input,select').prop('disabled',true)


  #########  create events ###############
  if $('.new_event')[0]

    $('#event_title').val("My #{Date.parse($('#event_start_date').val()).toString("dddd")} event")

)