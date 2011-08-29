
$('#use_address').live('click', function() {
  $('#address_suggest').show();
  $('#address_suggest input').focus();
})

$('#address_suggest input').live('keyup', function () {
  var geocoder = new google.maps.Geocoder();
  var input = $(this);
  var box = $('#address_suggest ul');
  geocoder.geocode({ address: input.val(), region: 'us'}, function(results, status) {
    if (status == 'OK') {
      box.empty();

      _.each(results, function(address) {
        var country = '', zip_code = '';
        _.each(address.address_components, function(component) {
          if (_.include(component.types, 'postal_code')) {
            zip_code = component.short_name;
          }
          if (_.include(component.types, 'country')) {
            country = component.short_name;
          }
        });

        if (country == 'US' && zip_code != '') {
          var li = $('<li><a href="#">' + address.formatted_address + '</a></li>');
          var atag = li.find('a');
          atag.data('zip', zip_code);
          box.append(li);
        }
      });
    }
  })
});


$('#address_suggest li a').live('click', function() {
  var atag = $(this);
  var zip = atag.data('zip');
  $('#zip_code').val(zip);
  $('#address_suggest ul').empty();
  $('#address_suggest').hide();
  $('#zip_code').parents('form').submit();
})

