window.CalendarOptions = {
  mode :  'liquid',
  header : {
    left: 'prev,next today',
    center: 'title',
    right: 'month,agendaWeek'
  },
  events_url : '/businesses/events'
}

$(document).ready( ->
  return unless $('.calendar_content')[0]

  $('select#business_id').change( ->
    select = $(this)
    window.location.href = "/businesses/#{select.val()}"
  )

  eventDataParams = (start_time,end_time)->
    {
      '_method': 'get',
      'start_time': start_time.toString('yyyy-MM-dd HH:mm tt'),
      'end_time': end_time.toString('yyyy-MM-dd HH:mm tt')
    }

  openDialog = (url, title, params)->
    $('#event_pop_up').load( url, params, ->
      $('#event_pop_up').dialog({
        modal:true,
        title: title,
        resizable:false,
        width:375,
        height:435,
        closeOnEscape: false,
        # need to enable the select again after modal is closed
        # this is should not be needed ...
        close: -> $('select#business_id').attr( 'disabled', false)
      })
    )

  window.eventClickHandler = (event) ->
    openDialog(event.url, "Edit Existing Event", eventDataParams(event.start, event.end)) if (event.url)
    return false

  window.calendarDayClickHandler = (date, allDay, jsEvent, view) ->
    time_now = new Date()
    start_time = date.clearTime().add( { hour: time_now.getHours(), minute: time_now.getMinutes() } )
    end_time = start_time.clone().add( { hour: 1 } )
    openDialog('/events/new', "Create New Event", eventDataParams(start_time, end_time))
    return false

  window.loadingCalendarHandler = (bool) ->

)