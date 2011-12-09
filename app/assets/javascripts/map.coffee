#############  Map view #############
class window.MapView
  icon: null
  el: $('#map_canvas')
  center_point: null
  center_marker: null
  view: null

  options: {
    mapTypeId: google.maps.MapTypeId.ROADMAP
    mapTypeControl: false
  }

  constructor: (@collection, @center_point)->
    this.render()
    map_view = this
    @collection.bind('reset', -> map_view.render() )

  prepareMap: ->
    return unless document.getElementById("map_canvas")
    if !@view
      @view = new google.maps.Map(document.getElementById("map_canvas"), @options)

  createCenterMarker: ->
    if @center_point
      point = new google.maps.LatLng(@center_point.lat, @center_point.lng)
      @center_marker = new google.maps.Marker({
        position: point,
        map: @view,
        title: @center_point.title
        icon: "/assets/arrow.png"
      })
    @markerBounds.extend(@center_marker.position) if @markerBounds and @center_marker

  setMarkers: (map, markerBounds) ->
    _.each( @collection.models, (business) ->
      if window.filter.match(business)
        business.setMarker(map, markerBounds)
    )

  clear: ->
    if @center_marker
      @center_marker.setMap(null)
      @center_marker = null
    @markerBounds = new google.maps.LatLngBounds()

  render: ->
    this.clear()
    this.prepareMap()
    this.createCenterMarker()
    this.setMarkers(@view, @markerBounds)


############  SingleZoomMap view #############
class window.SingleZoomMapView extends MapView
  constructor: (@model, @center_point)->
    throw "you need a model to make a MapView" unless @model

  options: {
    mapTypeId: google.maps.MapTypeId.ROADMAP
    mapTypeControl: false
    zoom: 17
  }

  render: ->
    this.model.clearMarker()
    this.prepareMap()
    @model.setMarker(@view)
    @view.setCenter(@model.marker.position)


############  ExtendBoundMap view #############
class window.ExtendBoundMapView extends MapView

  markerBounds: new google.maps.LatLngBounds()
  markerBoundsZoomOut: 0.1

  render: ->
    super()
    # extend the bounds if its too small
    if (this.markerBounds.getNorthEast().equals(this.markerBounds.getSouthWest()))
      extendPoint = new google.maps.LatLng(
        this.markerBounds.getNorthEast().lat() + this.markerBoundsZoomOut,
        this.markerBounds.getNorthEast().lng() + this.markerBoundsZoomOut
      )
      this.markerBounds.extend(extendPoint)
    @view.fitBounds(this.markerBounds)
