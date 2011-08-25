$(document).ready( ->
  return unless $('body.events_calendar')[0]

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
        width:370,
        height:425,
        closeOnEscape: false,
      })
    )

  window.eventClickHandler = (event) ->
    openDialog(event.url, "Edit Existing Event", eventDataParams(event.start, event.end)) if (event.url)
    return false

  window.calendarDayClickHandler = (date, allDay, jsEvent, view) ->
    time_now = new Date()
    start_time = date.clearTime().add( { hour: time_now.getHours(), minute: time_now.getMinutes() } )
    end_time = start_time.clone().add( { hour: 1 } )
    openDialog('events/new', "Create New Event", eventDataParams(start_time, end_time))
    return false

  window.loadingCalendarHandler = (bool) ->

)