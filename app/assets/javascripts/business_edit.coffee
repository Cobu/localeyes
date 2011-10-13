$(document).ready( ->
  return unless $( "#map_canvas" )[0]

  business_json = $('#business_data').data('info')
  business = new window.Business(business_json)
  window.map_view = new SingleZoomMapView(business)
  window.map_view.render()

  $('#business_lat, #business_lng').live('keyup', ->
    business.set( {lat: $('#business_lat').val(), lng: $('#business_lng').val()} )
    window.map_view.render()
  )

  $('#business_service_type').live('change', ->
    business.set( { service_type: $('#business_service_type').val() } )
    window.map_view.render()
  )

  $('#geo_lookup_id').live('change', (event)->
    elem = $(event.currentTarget)
    address = _.map(['address', 'address2', 'city', 'state', 'zip_code'], (field)->
      $("#business_#{field}").val()
    ).join(' ')
    $.get("/businesses/geocode", { address: address, geo_lookup: elem.val() }, (data)->
      business.set({ lat: data[0], lng: data[1] })
      $("#business_lat").val(data[0])
      $("#business_lng").val(data[1])
      window.map_view.render()
    )
  )
)