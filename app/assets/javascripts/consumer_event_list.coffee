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
     business : ->
       business_list.get(this.get('business_id'))
     business_name : -> this.business().get('name')
     user_favorite_image : ->
       prefix = if _.include( Filter.userFavorites, this.get('business_id') ) then '' else 'un'
       "<img src='assets/fav_#{prefix}selected.gif' width='20px' data-busniess_id='#{this.get('business_id')}' rel='favorite'/>"
  })

  window.Business = Backbone.Model.extend({ })

  window.BusinessList = Backbone.Collection.extend({
    model: Business
    filteredModels: ->
      _.filter( this.models, (model)->
        model
      )
  })

  class MapView
    el : $('#map_canvas')
    tooltip_template : Handlebars.compile(" {{name}}\n{{address}}\n{{city}},{{state}} ")
    center_point : null
    map : {
      options : {
        mapTypeId: google.maps.MapTypeId.ROADMAP
      },
      view : null
      markers : []
      markerBounds : new google.maps.LatLngBounds()
    }

    prepareMap : ->
      if !this.map.view
        this.map.view = new google.maps.Map(document.getElementById("map_canvas"), this.map.options)


    clear : ->
      console.log(this.map.markers)
      _.each( this.map.markers, (marker)-> marker.setMap(null) )
      this.map.markers = []
      this.map.markerBounds = new google.maps.LatLngBounds();

      if (this.center_point)
        point = new google.maps.LatLng(this.center_point.lat, this.center_point.lng)
        this.map.markerBounds.extend(point)
        new google.maps.Marker({
          position: point,
          map: this.map.view,
          title: this.center_point.title
          icon: "http://www.google.com/mapfiles/arrow.png"
        })

    render : ->
      this.prepareMap()
      this.clear()
      $.each(business_list.filteredModels(), (index, business)->
        business.image = map_view.makeImage(index)
        business.point = new google.maps.LatLng(business.attributes.lat,business.attributes.lng)
        map_view.map.markers.push(map_view.makeMarker(business))
        map_view.map.markerBounds.extend(business.point)
      )
      # here you extend your bound as you like
      if (map_view.map.markerBounds.getNorthEast().equals(map_view.map.markerBounds.getSouthWest()))
        extendPoint = new google.maps.LatLng(map_view.map.markerBounds.getNorthEast().lat() + 0.1, map_view.map.markerBounds.getNorthEast().lng() + 0.1)
        map_view.map.markerBounds.extend(extendPoint)
      this.map.view.fitBounds(map_view.map.markerBounds)


    makeMarker : (business)->
      new google.maps.Marker({
        position: business.point
        map: this.map.view
        title: this.tooltip_template(business.attributes)
        icon: business.image
      })

    makeImage : (index)->
      "http://www.google.com/mapfiles/marker" + this.makeLetter(index) + ".png"

    makeLetter : (number)->
      return '' unless (number >= 0 && number <= 26)
      String.fromCharCode(number + 65)




  window.EventList = Backbone.Collection.extend({
    url: '/consumers/events'
    model: Event
    filteredModels: ->
      _.filter( this.models, (model)->
        model
      )
  })


  window.EventView = Backbone.View.extend({
    el: $( '#event_list' )
    day_header_template : Handlebars.compile($( '#day_header_template' ).html())
    event_template : Handlebars.compile($( '#event_template' ).html())
    event_list_header : Handlebars.compile($( '#event_list_header' ).html())

    render: ->
      this.el.empty()
      this.el.append( this.event_list_header() )

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
      type = 'pull'
      if _.include( Filter.userFavorites, business_id )
        Filter.userFavorites = _.without( Filter.userFavorites, business_id )
      else
        Filter.userFavorites.push(business_id)
        type = 'push'
      $.get('/users/set_favorite',{ b:business_id, t: type})
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

  $('.filter input[name=filtering_favorites]').live('click', (event)->
    elem = $(event.currentTarget)
    filter.setFilteringByFavorites( elem.prop('checked') )
  )

  $('.images img[rel=favorite]').live('click', (event)->
    elem = $(event.currentTarget)
    filter.setFavorite( elem.data('busniess_id') )
  )
)