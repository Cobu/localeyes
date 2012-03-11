class App.View.MapView extends Backbone.View
  icon: null
  center_marker: null
  view: null
  className: 'map_canvas'

  options: {
    mapTypeId: null
    mapTypeControl: false
  }

  initialize: (options)->
    $(@el).attr('id', 'map_canvas')
    @options.mapTypeId = google.maps.MapTypeId.ROADMAP
    @need_rendering = true

  prepareMap: ->
    return unless document.getElementById("map_canvas")
    if !@view
      @view = new google.maps.Map(document.getElementById("map_canvas"), @options)

  createCenterMarker: ->
    if @location.get('center_point')
      center_point = @location.get('center_point')
      point = new google.maps.LatLng(center_point.lat, center_point.lng)
      @center_marker = new google.maps.Marker({
        position: point,
        map: @view,
        title: center_point.title
        icon: "/assets/arrow.png"
      })
    @markerBounds.extend(@center_marker.position) if @markerBounds and @center_marker

  setMarkers: (map, markerBounds) ->
    _.each( @collection.models, (business) =>
      business.clearMarker()
      if @container_view.filter.match(business)
        business.setMarker(map, markerBounds)
    )

  clear: ->
    if @center_marker
      @center_marker.setMap(null)
      @center_marker = null
    @markerBounds = new google.maps.LatLngBounds()

  reRender: ->
    if @need_rendering == true
      @view = null
      @render()
      @need_rendering = false

  render: ->
    this.clear()
    this.prepareMap()
    this.createCenterMarker()
    this.setMarkers(@view, @markerBounds)



############  SingleZoomMap view #############
class App.View.SingleZoomMapView extends App.View.MapView

  initialize: (options)->
    @model = options.model
    throw "you need a model to make a MapView" unless @model
    super(options)
    @options.zoom = 17

  render: ->
    @model.clearMarker()
    @prepareMap()
    @model.setMarker( @view )
    @view.setCenter( @model.marker.position )


############  ExtendBoundMap view #############
class App.View.ExtendBoundMapView extends App.View.MapView

  markerBoundsZoomOut: 0.1

  initialize: (options)->
    @collection = options.collection
    @container_view = options.consumer_events_view
    @location = @container_view.location
    @collection.bind('reset', => @render(); @need_rendering = true ) if @collection
    @container_view.filter.bind('change:service_types', => @render(); @need_rendering = true ) if @container_view
    super(options)
    @markerBounds = new google.maps.LatLngBounds()

  render: ->
    super()
    # extend the bounds if its too small
    if (this.markerBounds.getNorthEast().equals(this.markerBounds.getSouthWest()))
      extendPoint = new google.maps.LatLng(
        this.markerBounds.getNorthEast().lat() + this.markerBoundsZoomOut,
        this.markerBounds.getNorthEast().lng() + this.markerBoundsZoomOut
      )
      this.markerBounds.extend(extendPoint)
    @view.fitBounds(this.markerBounds) if @view
