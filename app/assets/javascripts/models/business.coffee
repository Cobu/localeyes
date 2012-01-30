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
