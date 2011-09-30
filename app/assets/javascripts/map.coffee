class window.MapView
  icon : null
  el : $('#map_canvas')
  center_point : null
  center_marker : null
  map : {
    options : {
      mapTypeId: google.maps.MapTypeId.ROADMAP
      mapTypeControl: false,
    },
    view : null
    markerBounds : new google.maps.LatLngBounds()
    markerBoundsZoomOut : 0.1
  }

  prepareMap : ->
    if !this.map.view
      this.map.view = new google.maps.Map(document.getElementById("map_canvas"), this.map.options)

  addCenterPoint : ->
    if this.center_point
      point = new google.maps.LatLng(this.center_point.lat, this.center_point.lng)
      this.center_marker = new google.maps.Marker({
        position: point,
        map: this.map.view,
        title: this.center_point.title
        icon: "/assets/arrow.png"
      })
      this.map.markerBounds.extend(point)

  clear : ->
    if window.business_list
      window.business_list.clearMarkers()
    if this.center_marker
      this.center_marker.setMap(null)
      this.center_marker = null
    this.map.markerBounds = new google.maps.LatLngBounds();

  render : ->
    this.prepareMap()
    this.clear()
    if window.business_list
      business_list.setMarkers(this.map.view, this.map.markerBounds)
    this.addCenterPoint()

    # extend the bounds if its too small
    if (map_view.map.markerBounds.getNorthEast().equals(map_view.map.markerBounds.getSouthWest()))
      extendPoint = new google.maps.LatLng(
        map_view.map.markerBounds.getNorthEast().lat() + map_view.map.markerBoundsZoomOut,
        map_view.map.markerBounds.getNorthEast().lng() + map_view.map.markerBoundsZoomOut
      )
      map_view.map.markerBounds.extend(extendPoint)
    this.map.view.fitBounds(map_view.map.markerBounds)
