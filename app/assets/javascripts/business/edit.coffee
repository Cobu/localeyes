$(document).ready( ->
  return unless $( "#map_canvas" )[0]

  business_json = $('#business_data').data('info')
  business = new window.Business(business_json)
  window.map_view = new SingleZoomMapView(business)
  window.map_view.render() if business.get('id')

  resetCoordinates = (geo_lookup_type)->
    address_arr = _.compact(_.map(['address', 'city', 'state', 'zip_code'], (field)->
      $("#business_#{field}").val()
    ))

    unless address_arr.length == 4
      alert( "need to have a full address set first")
      return

    geo_lookup_type = $('#geo_lookup_id').val()
    address = address_arr.join(' ')

    $.get("/businesses/geocode", { address: address, geo_lookup: geo_lookup_type }, (data)->
      business.set({ lat: data[0], lng: data[1] })
      $("#business_lat").val(data[0])
      $("#business_lng").val(data[1])
      window.map_view.render()
    )

  $('#geo_lookup_id').live('change', -> resetCoordinates() )
  $('#geo_lookup_button').live('click', -> resetCoordinates() )
)