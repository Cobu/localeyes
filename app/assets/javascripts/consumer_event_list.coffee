Handlebars.registerHelper("rounded", (number)->
  if (number != undefined)
    parseFloat(number).toFixed(2)
)

Handlebars.registerHelper("hours", (string)->
  return unless _.isString(string)
  string
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

  $('#event_list_inner').qvivoScroll()

  window.Event = Backbone.Model.extend({
     startDate : -> Date.parse(this.get('start')).toString("yyyy-MM-dd")
     startHour : -> Date.parse(this.get('start')).toString("h:mm tt")
     business : -> business_list.get(this.get('business_id'))
     businessName : -> this.business().get('name')
     userFavoriteImage : ->
       prefix = if _.include( Filter.userFavorites, this.get('business_id') ) then '' else 'un'
       "<img src='assets/fav_#{prefix}selected.gif' width='20px' data-busniess_id='#{this.get('business_id')}' rel='favorite'/>"
  })

  window.Business = Backbone.Model.extend({
    service_type_names : ['Cafe', 'Restaurant', 'Bar']
    serviceName : -> this.service_type_names[this.get('service_type')].toLowerCase()
    template: Handlebars.compile($( '#business_info_template' ).html())
    map_tooltip_template : Handlebars.compile(" {{name}}\n{{address}}\n{{city}},{{state}} ")
    render : -> this.template(this)
    marker : null
    clearMarker : ->
      if this.marker
        this.marker.setMap(null)
        this.marker = null
    setMarker : (map, markerBounds)->
      this.point = new google.maps.LatLng(this.get('lat'),this.get('lng'))
      this.marker = this.makeMarker(map)
      markerBounds.extend(this.point)

    makeMarker : (map)->
      new google.maps.Marker({
        position: this.point
        map: map
        title: this.map_tooltip_template(this.attributes)
        icon: this.makeIcon()
      })

    makeIcon : (scaleFactor)->
      scaleFactor = 1 if (scaleFactor == undefined)
      new google.maps.MarkerImage(
        "/assets/#{this.serviceName()}.png", null , null , null ,
        new google.maps.Size(20*scaleFactor, 34*scaleFactor)
      )
  })

  window.BusinessList = Backbone.Collection.extend({
    model: Business
    selected : null
    filteredModels: ->  _.filter( this.models, (model)->  model )
    clearMarkers : -> _.each( this.models, (business)->  business.clearMarker() )
    setMarkers : (map, markerBounds) ->  _.each( this.models, (business)-> business.setMarker(map, markerBounds) )
    setSelected : (id)->
      if (this.selected)
        business = this.get(this.selected)
        this.get(this.selected).marker.setIcon(business.makeIcon())
      business = this.get(id)
      business.marker.setIcon(business.makeIcon(1.3))
      this.selected = id
  })

  class MapView
    icon : null
    el : $('#map_canvas')
    center_point : null
    center_marker : null
    map : {
      options : {
        mapTypeId: google.maps.MapTypeId.ROADMAP
        mapTypeControl: false,
      },
      view : null
      markerBounds : new google.maps.LatLngBounds()
    }

    prepareMap : ->
      if !this.map.view
        this.map.view = new google.maps.Map(document.getElementById("map_canvas"), this.map.options)

    addCenterPoint : ->
      point = new google.maps.LatLng(this.center_point.lat, this.center_point.lng)
      this.center_marker = new google.maps.Marker({
        position: point,
        map: this.map.view,
        title: this.center_point.title
        icon: "/assets/arrow.png"
      })
      this.map.markerBounds.extend(point)

    clear : ->
      business_list.clearMarkers()
      if this.center_marker
        this.center_marker.setMap(null)
        this.center_marker = null
      this.map.markerBounds = new google.maps.LatLngBounds();

    render : ->
      this.prepareMap()
      this.clear()
      business_list.setMarkers(this.map.view, this.map.markerBounds)
      this.addCenterPoint()

      # extend the bounds if its too small
      if (map_view.map.markerBounds.getNorthEast().equals(map_view.map.markerBounds.getSouthWest()))
        extendPoint = new google.maps.LatLng(map_view.map.markerBounds.getNorthEast().lat() + 0.1, map_view.map.markerBounds.getNorthEast().lng() + 0.1)
        map_view.map.markerBounds.extend(extendPoint)
      this.map.view.fitBounds(map_view.map.markerBounds)


  window.EventList = Backbone.Collection.extend({
    url: '/consumers/events'
    model: Event
    filteredModels: -> _.filter( this.models, (model)->  model )
  })

  $('.event .info').live('click', (event)->
    elem = $(event.currentTarget).parent('.event')
    event = event_list.get(elem.data('id'))
    business_elem = elem.next('.business')
    if business_elem[0]
      business_elem.slideUp('slow', -> business_elem.remove())
      return
    business_list.setSelected(event.business().get('id')) # to grow the icon
    business_elem = $(event.business().render())
    elem_event_class = elem.attr('class').match(/\w+_type/)[0]
    business_elem.addClass(elem_event_class)
    elem.after(business_elem)
    business_elem.slideDown('slow')
  )


  window.EventView = Backbone.View.extend({
    el: $( '#event_list' )
    day_header_template : Handlebars.compile($( '#day_header_template' ).html())
    event_template : Handlebars.compile($( '#event_template' ).html())

    render: ->
      this.el.empty()

      events = _(event_list.models).groupBy( (event)-> event.startDate() )
      for num in [0..13]
        date = Date.today().addDays(num)
        days_events = _.select(events[date.toString("yyyy-MM-dd")], (event)-> filter.match(event) )
        continue unless _.any(days_events)
        this.buildEventsForDay( date, days_events )

    buildEventsForDay : ( date, events )->
      this.el.append( this.day_header_template({'date': date}) )
      _.each(events, (event)-> event_view.el.append( event_view.event_template(event) ) )
  })

  window.event_list = new EventList
  window.event_view = new EventView
  window.map_view = new MapView

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
      window.event_view.render()

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

    match : (event)->
      if Filter.filtering_favorites then return false unless _.include( Filter.userFavorites, event.get('business_id') )
      _.include( Filter.serviceTypes, event.business().get('service_type') )

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