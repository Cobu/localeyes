$(document).ready( ->
  return unless $( "#map_canvas" )[0]

  window.map_view = new MapView
  window.map_view.map.markerBoundsZoomOut = 0.001
  business_json = $('#business_data').data('info')
  business = new window.Business(business_json)
  window.business_list = new window.BusinessList([business])
  window.map_view.render()

  $('#business_lat, #business_lng').live('keyup', ->
    business.set( {lat: $('#business_lat').val(), lng: $('#business_lng').val()} )
    window.map_view.render()
  )
)