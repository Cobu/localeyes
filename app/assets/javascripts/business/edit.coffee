$(document).ready(->
    window.BusinessEdit = {}
    window.BusinessEdit.closeAuthPopup = (auth_type)->
      section = $(".auth_section.#{auth_type}")
      section.find('.text').show()
      section.find('.link').hide()

    return unless $("#map_canvas")[0]

    business_json = $('#business_data').data('info')
    business = new window.Business(business_json)
    window.map_view = new SingleZoomMapView(business)
    if business.get('id')
      window.map_view.render()
      $('#geo_lookup_button').hide()

    authentications_json = $('.auth_panel').data('auth')
    console.log(authentications_json)

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