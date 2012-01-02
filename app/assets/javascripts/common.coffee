$(document).ready( ->

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

)