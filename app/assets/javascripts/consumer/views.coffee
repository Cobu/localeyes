Handlebars.registerHelper("rounded", (number)->
  if (number != undefined)
    parseFloat(number).toFixed(2)
)

Handlebars.registerHelper("hour", (string)->
  return unless _.isString(string)
  date = Date.parseExact(string,"yyyy-MM-ddTH:mm:ssZ")
  if date then date.toString('h:mm tt') else ''
)

Handlebars.registerHelper("phone_format", (phone) ->
  return if _.isEmpty(phone)
  phone = phone.toString()
  "(" + phone.substr(0,3) + ") " + phone.substr(3,3) + "-" + phone.substr(6,4)
)

window.short_dayname = ['Su', 'M', 'T', 'W', 'Th', 'F', 'Sa']
window.hours_template = Handlebars.compile("{{hour from}} - {{hour to}}")
Handlebars.registerHelper("each_hour", (array, fn)->
	buffer = ""
	for num in [0..array.length-1]
		item = array[num]
    # add the day_name property onto the hours
		item.day_name = short_dayname[num]
		if (item.open == true)
		  item.hour_value = window.hours_template(item)
		else
		  item.hour_value = "Closed"
		# show the inside of the block
		buffer += fn(item)
	buffer # return the finished buffer
)

Handlebars.registerHelper("header", (date)->
  return unless _.isDate(date)
  str = if date.equals(Date.today())
    "Today"
  else if date.equals(Date.today().addDays(1))
    "Tommorrow"
  else
    date.toString('dddd')
  str += " #{date.toString('MMMM d')}"
)


$(document).ready( ->

  ############  Event view #############
  window.EventView = Backbone.View.extend(
    template: Handlebars.compile($( '#event_template' ).html())
    tagName: 'li'

    initialize: (@event)-> this.render()

    showBusiness: ->
      elem = this.el
      elem.find('.description').show()
      business_elem = elem.next('.business')
      if business_elem[0]
        business_elem.slideUp('slow', ->
          business_elem.remove()
          elem.find('.description').hide()
        )
        business_list.clearSelected() # to shrink the icon
        return
      business_list.setSelected(@event.business().get('id')) # to grow the icon
      new BusinessView( this )

    render: ->
      if @event != undefined
        this.el = $(this.template(@event))
        this.el.find('.info, .description').bind('click', => this.showBusiness() )
      this
  )

  ############  EventList view #############
  window.EventListView = Backbone.View.extend({
    el: $( '#event_list' )
    day_header_template: Handlebars.compile($( '#day_header_template' ).html())

    initialize: (@event_list)->
      if @event_list
        this.render()
      else
        @event_list = []
      @event_list.bind('reset', => this.render() )

    showDescription: (event)->
      elem = $(event.currentTarget).parent('.event')

    render: ->
      this.el.empty()
      events = _(@event_list.models).groupBy( (event)-> event.startDate() )
      for num in [0..13]
        date = Date.today().addDays(num)
        days_events = _.select( events[date.toString("yyyy-MM-dd")], (event)-> window.filter.match(event.business()) )
        continue unless _.any(days_events)
        this.buildEventsForDay( date, days_events )

    buildEventsForDay: ( date, events )->
      this.el.append( this.day_header_template({'date': date}) )
      _.each(events, (event)->
        event_view = new EventView(event)
        event_list_view.el.append( event_view.el )
      )
  })


  window.BusinessView = Backbone.View.extend(
    template: null

    initialize: (@event_view)->
      @template = Handlebars.compile($( '#business_info_template' ).html())
      this.render()

    render: ->
      business_elem = $( @template( @event_view.event.business() ) )
      elem_event_class = @event_view.el.attr('class').match(/\w+_type/)[0]
      business_elem.addClass( elem_event_class )
      @event_view.el.after( business_elem )
      business_elem.slideDown( 'slow' )
  )


  class window.Filter
    service_type_constants = {
      service_type_cafe : 0
      service_type_restaurant : 1
      service_type_bar : 2
    }
    @service_type_cafe = true
    @service_type_restaurant = true
    @service_type_bar = true
    @serviceTypes = [0, 1, 2]
    @filtering_favorites = false
    @userFavorites = []

    setServiceType : (type, value)->
      Filter[type] = value
      Filter.serviceTypes = []
      for name of service_type_constants
        if Filter[name] then Filter.serviceTypes.push service_type_constants[name]
      window.event_list_view.render()
      window.map_view.render()

    setFilteringByFavorites : (bool)->
      Filter.filtering_favorites = bool
      window.event_view.render()

    setFavorite : (business_id)->
      if _.include( Filter.userFavorites, business_id )
        $.get('/users/unset_favorite',{ b:business_id})
        Filter.userFavorites = _.without( Filter.userFavorites, business_id )
      else
        Filter.userFavorites.push(business_id)
        $.get('/users/set_favorite',{ b:business_id})
      window.event_view.render()

    match : (business)->
      if Filter.filtering_favorites then return false unless _.include( Filter.userFavorites, business.get('id') )
      _.include( Filter.serviceTypes, business.get('service_type') )

    setValues : ->
      $('.filter input[type=checkbox]').each( (index,elem)->
        id = $(elem).attr('id')
        $(elem).prop('checked', Filter[id])
      )

  window.filter = new window.Filter()


  $('.filter input[name^=service_type]').live('click', (event)->
    elem = $(event.currentTarget)
    filter.setServiceType( elem.attr('id'), elem.prop('checked') )
  )

  $('input[name=filtering_favorites]').live('click', (event)->
    elem = $(event.currentTarget)
    filter.setFilteringByFavorites( elem.prop('checked') )
  )

  $('.images img[rel=favorite]').live('click', (event)->
    elem = $(event.currentTarget)
    filter.setFavorite( elem.data('busniess_id') )
  )
)