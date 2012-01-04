
#..hack..###########  Event model #############
window.Event = Backbone.Model.extend({
  startDate: -> Date.parse(this.get('start')).toString("yyyy-MM-dd")
  startHour: -> Date.parse(this.get('start')).toString("h:mm tt")
  business: -> business_list.get(this.get('business_id'))
  businessName: -> this.business().get('name')
  businessImageName: -> this.business().imageName()
  userFavoriteImage: ->
    prefix = if _.include( Filter.userFavorites, this.get('business_id') ) then '' else 'un'
    "<img src='assets/fav_#{prefix}selected.gif' width='20px' data-business_id='#{this.get('business_id')}' rel='favorite'/>"
})

############  EventList Collection #############
window.EventList = Backbone.Collection.extend({
  url: '/consumers/events'
  model: Event
})


############  Business model #############
window.Business = Backbone.Model.extend(
  service_type_names: ['Cafe', 'Restaurant', 'Bar', 'Retail']
  marker: null
  map_tooltip_template: Handlebars.compile("{{name}}\n{{address}}\n{{city}},{{state}}")

  serviceName: ->
    return '' unless _.isNumber(parseInt(this.get('service_type')))
    @service_type_names[this.get('service_type')].toLowerCase()

  imageName: -> "/assets/#{this.serviceName()}.png"

  renderHours: (item)-> window.hours_template(item)

  clearMarker: ->
    if @marker
      @marker.setMap(null)
      @marker = null

  setMarker: (map, markerBounds)->
    @point = new google.maps.LatLng(this.get('lat'),this.get('lng'))
    @marker = this.makeMarker(map)
    markerBounds.extend(@point) if markerBounds

  setMarkerIcon: (scaleFactor)-> @marker.setIcon( this.makeIcon(scaleFactor) )

  makeMarker: (map)->
    new google.maps.Marker({
      position: @point
      map: map
      title: this.map_tooltip_template(this.attributes)
      icon: this.makeIcon()
    })

  makeIcon: (scaleFactor)->
    scaleFactor = 1 if (scaleFactor == undefined)
    new google.maps.MarkerImage(
      this.imageName(), null , null , null ,
      new google.maps.Size(20*scaleFactor, 30*scaleFactor)
    )
)

############  BusinessList Collection #############
window.BusinessList = Backbone.Collection.extend(
  model: Business
  selected_id: null
  selected_view: null
  # override rest to clear the business markers in old collection before
  # the new collection takes its place
  reset: (collection)->
    _.each( @models, (business)-> business.clearMarker() )
    Backbone.Collection.prototype.reset.call(this, collection)

  clearSelected: ->
    this.get( @selected_id ).setMarkerIcon() if @selected_id
    @selected_id = null
    @selected_view.close() if @selected_view
    @selected_view = null

  setSelected: (business_id, business_view)->
    this.get( @selected_id ).setMarkerIcon() if @selected_id # shrink icon
    this.get( business_id ).setMarkerIcon(1.3) # bigger icon
    @selected_id = business_id
    @selected_view = business_view
)




