class window.MapView
  constructor: (@collection, @props)->
    throw "you need a collection to make a MapView" unless @collection

  icon: null
  el: $('#map_canvas')
  center_point: null
  center_marker: null
  view: null

  options: {
    mapTypeId: google.maps.MapTypeId.ROADMAP
    mapTypeControl: false
  }

  prepareMap: ->
    if !this.view
      this.view = new google.maps.Map(document.getElementById("map_canvas"), this.options)

  createCenterMarker: ->
    if this.center_point
      point = new google.maps.LatLng(this.center_point.lat, this.center_point.lng)
      this.center_marker = new google.maps.Marker({
        position: point,
        map: this.view,
        title: this.center_point.title
        icon: "/assets/arrow.png"
      })
    this.markerBounds.extend(this.center_marker.position) if this.markerBounds and this.center_marker

  setMarkers: (map, markerBounds) ->
    _.each( @collection.models, (model)-> model.setMarker(map, markerBounds) )

  clear: ->
    this.collection.clearMarkers()
    if this.center_marker
      this.center_marker.setMap(null)
      this.center_marker = null
    this.markerBounds = new google.maps.LatLngBounds()

  render: ->
    this.clear()
    this.prepareMap()
    this.createCenterMarker()
    this.setMarkers(this.view, this.markerBounds)


class window.SingleZoomMapView extends MapView
  constructor: (@model, @props)->
    throw "you need a collection to make a MapView" unless @model

  options: {
    mapTypeId: google.maps.MapTypeId.ROADMAP
    mapTypeControl: false
    zoom: 17
  }

  render: ->
    this.model.clearMarker()
    this.prepareMap()
    this.model.setMarker(this.view)
    this.view.setCenter(this.model.marker.position)



class window.ExtendBoundMapView extends MapView

  markerBounds: new google.maps.LatLngBounds()
  markerBoundsZoomOut: 0.001

  render: ->
    super
    # extend the bounds if its too small
    if (this.markerBounds.getNorthEast().equals(this.markerBounds.getSouthWest()))
      extendPoint = new google.maps.LatLng(
        this.markerBounds.getNorthEast().lat() + this.markerBoundsZoomOut,
        this.markerBounds.getNorthEast().lng() + this.markerBoundsZoomOut
      )
      this.markerBounds.extend(extendPoint)
    this.view.fitBounds(this.markerBounds)
