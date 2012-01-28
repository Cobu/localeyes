
#..hack..###########  Event model #############
window.Event = Backbone.Model.extend(
  startDate: -> Date.parse( this.get('start') ).toString("yyyy-MM-dd")
  startHour: -> Date.parse( this.get('start') ).toString("h:mm")
  startAmPm: -> Date.parse( this.get('start') ).toString("tt")
  business: -> business_list.get( this.get('business_id') )
  businessName: -> this.business().get('name')
  businessImageName: -> this.business().imageName()
  businessIconName: -> this.business().iconName()
  userFavoritePrefix: -> 'un' unless _.include( Filter.userFavorites, this.get('business_id') )
)

############  EventList Collection #############
window.EventList = Backbone.Collection.extend({
  url: '/consumers/events'
  model: Event
  comparator: (event)-> event.get('start')
})


############  Business model #############
window.Business = Backbone.Model.extend(
  service_type_names: ['Cafe', 'Restaurant', 'Bar', 'Retail']
  marker: null
  map_tooltip_template: Handlebars.compile("{{name}}\n{{address}}\n{{city}},{{state}}")

  serviceName: ->
    return '' unless _.isNumber(parseInt(this.get('service_type')))
    @service_type_names[this.get('service_type')].toLowerCase()

  imageName: -> "/assets/#{this.serviceName()}_pin_small.png"
  iconName: -> "/assets/#{this.serviceName()}_icon.png"

  clearMarker: ->
    if @marker
      @marker.setMap(null)
      @marker = null

  setMarker: (map, markerBounds)->
    @point = new google.maps.LatLng(this.get('lat'), this.get('lng'))
    @marker = this.makeMarker(map)
    markerBounds.extend(@point) if markerBounds

  setMarkerIcon: (scaleFactor)-> @marker.setIcon(this.makeIcon(scaleFactor))

  makeMarker: (map)->
    new google.maps.Marker(
      position: @point
      map: map
      title: this.map_tooltip_template(this.attributes)
      icon: this.makeIcon()
    )

  makeIcon: (scaleFactor)->
    scaleFactor = 'small' unless scaleFactor
    new google.maps.MarkerImage(
      "/assets/#{this.serviceName()}_pin_#{scaleFactor}.png"
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
    @each((business)-> business.clearMarker())
    Backbone.Collection.prototype.reset.call(this, collection)

  clearSelected: ->
    this.get(@selected_id).setMarkerIcon() if @selected_id
    @selected_id = null
    @selected_view.close() if @selected_view
    @selected_view = null

  setSelected: (business_id, business_view)->
    # shrink icon
    this.get(@selected_id).setMarkerIcon() if @selected_id
    # bigger icon
    this.get(business_id).setMarkerIcon('large')
    @selected_id = business_id
    @selected_view = business_view
)




