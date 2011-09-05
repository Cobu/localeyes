Handlebars.registerHelper("rounded", (number)->
  if (number != undefined)
    parseFloat(number).toFixed(2)
)

Handlebars.registerHelper("header", (date)->
  return unless _.isDate(date)
  if date.equals(Date.today())
    "Today #{date.toString("yyyy-MM-dd")}"
  else if date.equals(Date.today().addDays(1))
    "Tommorrow #{date.toString("yyyy-MM-dd")}"
  else
    date.toString("yyyy-MM-dd")
)


$(document).ready( ->

  Event = Backbone.Model.extend({
     startDate : -> Date.parse(this.get('start')).toString("yyyy-MM-dd")
  })

  EventList = Backbone.Collection.extend({
    url: '/consumers/events'
    model: Event
  })

  EventView = Backbone.View.extend({
    el: $( '#event_list' )
    day_header_template : Handlebars.compile($( '#day_header_template' ).html())
    event_template : Handlebars.compile($( '#event_template' ).html())
    render: ->
      this.el.empty()
      events = _(event_list.models).groupBy( (event)-> event.startDate() )
      num = 0
      while num += 14
        date = Date.today().addDays(num)
        this.buildEventsForDay(date,events[date.toString("yyyy-MM-dd")])

    buildEventsForDay : (date,events)->
      return unless events
      this.el.append( this.day_header_template({'date': date}) )
      for event in events
        this.el.append( this.event_template(event.attributes) )
  })

  window.event = new Event
  window.event_list = new EventList
  window.event_view = new EventView

#  window.event_list.fetch({
#    data: {zip_code: 13126},
#    success: -> window.event_view.render()
#  })

)