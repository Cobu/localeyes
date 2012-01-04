$(document).ready(->
  ############## authentications ###################
  if $('#wrapper.business_edit')[0]
    class window.BusinessEdit
      template: Handlebars.compile($('#auth_connection_template').html())

      showAuthConnections: (auth_info)->
        auth_info = JSON.parse(auth_info) if _.isString(auth_info)

        connections = $(".auth_panel .connections")
        connections.find('connection').empty()
        _.each(auth_info, (info)=> connections.append(@template(info)) )

    window.business_edit = new BusinessEdit()

    auth_info = $('.auth_panel').data('auth')
    business_edit.showAuthConnections(auth_info)


  ################ map the business ############
  if $("#map_canvas")[0]
    business_json = $('#business_data').data('info')
    business = new window.Business(business_json)
    window.map_view = new SingleZoomMapView(business)
    if business.get('id')
      window.map_view.render()
      $('#geo_lookup_button').hide()

  $('#business_service_type').live('change', (event)->
    business.set({ service_type: $(this).val() })
    window.map_view.render()
  )

  ################# geocoder handlers #################
  resetCoordinates = (geo_lookup_type)->
    address_arr = _.compact(_.map(['address', 'city', 'state', 'zip_code'], (field)->
        $("#business_#{field}").val()
    ))

    unless address_arr.length == 4
      alert("need to have a full address set first")
      return false

    geo_lookup_type = $('#geo_lookup_id').val()
    address = address_arr.join(' ')

    $.get("/businesses/geocode", { address: address, geo_lookup: geo_lookup_type }, (data)->
        business.set({ lat: data[0], lng: data[1] })
        $("#business_lat").val(data[0])
        $("#business_lng").val(data[1])
        $("#business_geocoded_by").val(geo_lookup_type)
        window.map_view.render()
    )

  $('#geo_lookup_id').live('change', -> resetCoordinates())
  $('#geo_lookup_button').live('click', -> $(this).hide() if resetCoordinates())
)