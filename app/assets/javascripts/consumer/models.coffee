
# ###########  Event model #############
window.Event = Backbone.Model.extend({
  startDate: -> Date.parse(this.get('start')).toString("yyyy-MM-dd")
  startHour: -> Date.parse(this.get('start')).toString("h:mm tt")
  business: -> business_list.get(this.get('business_id'))
  businessName: -> this.business().get('name')
  userFavoriteImage: ->
    prefix = if _.include( Filter.userFavorites, this.get('business_id') ) then '' else 'un'
    "<img src='assets/fav_#{prefix}selected.gif' width='20px' data-busniess_id='#{this.get('business_id')}' rel='favorite'/>"
})

############  EventList model #############
window.EventList = Backbone.Collection.extend({
  url: '/consumers/events'
  model: Event
})


############  Business model #############
window.Business = Backbone.Model.extend(
  service_type_names: ['Cafe', 'Restaurant', 'Bar']
  marker: null
  map_tooltip_template: Handlebars.compile("{{name}}\n{{address}}\n{{city}},{{state}} ")

  serviceName: ->
    return '' unless _.isNumber(this.get('service_type'))
    this.service_type_names[this.get('service_type')].toLowerCase()

  renderHours: (item)-> this.hours_template(item)

  clearMarker: ->
#    console.log([1,this.marker])
    if this.marker
      this.marker.setMap(null)
      this.marker = null

  setMarker: (map, markerBounds)->
    console.log(this.marker)
    this.point = new google.maps.LatLng(this.get('lat'),this.get('lng'))
    this.marker = this.makeMarker(map)
    console.log([2,this.marker])
    if markerBounds
      markerBounds.extend(this.point)

  makeMarker: (map)->
    new google.maps.Marker({
      position: this.point
      map: map
      title: this.map_tooltip_template(this.attributes)
      icon: this.makeIcon()
    })

  makeIcon: (scaleFactor)->
    scaleFactor = 1 if (scaleFactor == undefined)
    new google.maps.MarkerImage(
      "/assets/#{this.serviceName()}.png", null , null , null ,
      new google.maps.Size(20*scaleFactor, 34*scaleFactor)
    )
)

############  BusinessList model #############
window.BusinessList = Backbone.Collection.extend(
  model: Business
  selected: null

  clearMarkers: -> _.each( @models, (business)->  business.clearMarker() )

  clearSelected: ->
    if (this.selected)
      business = this.get(this.selected)
      this.get(this.selected).marker.setIcon(business.makeIcon())
    this.selected = null

  setSelected: (id)->
    if (this.selected)
      business = this.get(this.selected)
      this.get(this.selected).marker.setIcon(business.makeIcon())
    business = this.get(id)
    business.marker.setIcon(business.makeIcon(1.3))
    this.selected = id
)




