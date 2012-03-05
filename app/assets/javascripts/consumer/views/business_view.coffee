class App.View.BusinessView extends Backbone.View
  tagName: 'li'
  className: 'business'

  initialize: (options)->
    @event_view = options.event_view
    @template = JST['consumer/business_info']
    @render()

  render: ->
    @elem = $(@el).html( @template(@event_view.model.business().toJSON() ) ).hide()
    @event_view.elem
      .after( @elem )
      .find('.description').addClass('open').show()
    @elem.slideDown('fast', =>
      # bold the day of the week on the hours list
      day_number = @event_view.date.getDay()
      @$(".line[data-day_num=#{day_number}]").addClass('bold')
    )

  close: ->
    @elem.slideUp('fast', =>
        @event_view.elem.find('.description').removeClass('open').hide()
        @elem.remove()
    )


window.short_dayname = ['Su', 'M', 'T', 'W', 'Th', 'F', 'Sa']
window.hours_template = Handlebars.compile("{{hour from}} - {{hour to}}")
Handlebars.registerHelper("each_hour", (array, fn)->
    buffer = ""
    for num in [0..array.length - 1]
      item = array[num]
      # add the day_name property onto the hours
      item.day_name = short_dayname[num]
      item.day_num = num
      if (item.open == true)
        item.hour_value = window.hours_template(item)
      else
        item.hour_value = "Closed"
      # show the inside of the block
      buffer += fn(item)
    buffer # return the finished buffer
)

