Handlebars.registerHelper("rounded", (number)->
  if (number != undefined)
    parseFloat(number).toFixed(2)
)

Handlebars.registerHelper("titleize", (string)->
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
     business : ->
       console.log(business_list.get(this.get('business_id')))
       business_list.get(this.get('business_id'))

     business_name : -> this.business().get('name')
  })

  window.Business = Backbone.Model.extend({ })

  window.BusinessList = Backbone.Collection.extend({
    model: Business
  })

  window.MapView = Backbone.View.extend({
    el : $('#map_canvas')
    tooltip_template : Handlebars.compile(" {{name}}\n{{address}}\n{{city}},{{state}} ")
    map : {
      options : {
        center: new google.maps.LatLng(43.46540069580078,-76.34220123291016)
        zoom: 10
        mapTypeId: google.maps.MapTypeId.ROADMAP
      },
      view : null
      point : null
      markerBounds : new google.maps.LatLngBounds()
    }

    prepareMap : ->
      if !this.map.view
        this.map.view = new google.maps.Map(document.getElementById("map_canvas"), this.map.options)


    clear : ->
      this.map.markerBounds = new google.maps.LatLngBounds();
      if (this.map.point)
        map.markerBounds.extend(this.map.point)
        new google.maps.Marker({
          position: this.map.point,
          map: this.map.view,
          # title: center_location.city + ", " + center_location.state,
          icon: "http://www.google.com/mapfiles/arrow.png"
        })

    render : ->
      this.prepareMap()
      $.each(business_list.models, (index, business)->
        business.image = map_view.makeImage(index)
        business.point = new google.maps.LatLng(business.attributes.lat,business.attributes.lng)
        map_view.setMarker(business)
#        map_view.map.markerBounds.extend(business.point)
      )
#      this.map.view.fitBounds(map_view.map.markerBounds)


    setMarker : (business)->
      marker = new google.maps.Marker({
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

  })


  window.EventList = Backbone.Collection.extend({
    url: '/consumers/events'
    model: Event
  })


  window.EventView = Backbone.View.extend({
    el: $( '#event_list' )
    day_header_template : Handlebars.compile($( '#day_header_template' ).html())
    event_template : Handlebars.compile($( '#event_template' ).html())

    render: ->
      this.el.empty()
      events = _(event_list.models).groupBy( (event)-> event.startDate() )
      for num in [0..13]
        date = Date.today().addDays(num)
        this.buildEventsForDay(date,events[date.toString("yyyy-MM-dd")])


    buildEventsForDay : (date,events)->
      return unless events
      this.el.append( this.day_header_template({'date': date}) )
      for event in events
        this.el.append( this.event_template( event ) )
  })

  window.event_list = new EventList
  window.event_view = new EventView
  window.map_view = new MapView

)