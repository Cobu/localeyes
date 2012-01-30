class App.Model.Event extends Backbone.Model
  startDate: -> Date.parse( this.get('start') ).toString("yyyy-MM-dd")
  startHour: -> Date.parse( this.get('start') ).toString("h:mm")
  startAmPm: -> Date.parse( this.get('start') ).toString("tt")
  business: -> business_list.get( this.get('business_id') )
  businessName: -> this.business().get('name')
  businessImageName: -> this.business().imageName()
  businessIconName: -> this.business().iconName()
  userFavoritePrefix: -> 'un' unless _.include( Filter.userFavorites, this.get('business_id') )



class App.Model.Business extends Backbone.Model
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





