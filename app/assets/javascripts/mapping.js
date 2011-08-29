Handlebars.registerHelper("rounded", function(number) {
  if (number != undefined) {
    return parseFloat(number).toFixed(2);
  }
});

Handlebars.registerHelper("titleize", function(string) {
  if (string != undefined) {
    return string.titleize();
  }
});


$(function() {
  if ($('#content.event_list')[0]) {
    Map.tooltip_template = Handlebars.compile($('#tooltip_template').html());
    Map.details_template = Handlebars.compile($('#details_template').html());
    var zip_code = $('input#zip_code').val();
    Map.find(zip_code);

    $('#more_event_list_toggler').click(function() {
      $(this).parent('p').remove();
      Map.show(10);
      $('#event_list_container p').hide();
    });

    $('#event_list_inner').qvivoScroll();
  }
});


var Map = {
  details_template : null,
  tooltip_template : null,
  data : [],
  show_num : 50,

  map : {
    options : {
      mapTypeId: "roadmap"
    },
    view : null,
    point : null,
    markerBounds : null
  },


  prepareMap : function() {
    if (!Map.map.view) {
      Map.map.view = new google.maps.Map(document.getElementById("map_canvas"), Map.map.options);
    }
  },

  clear : function() {
    $('#event_list').empty();
    $('#extra_event_list').empty();

    Map.map.markerBounds = new google.maps.LatLngBounds();
    if (Map.map.point) {
      Map.map.markerBounds.extend(Map.map.point);
      new google.maps.Marker({
        position: Map.map.point,
        map: Map.map.view,
        // title: center_location.city + ", " + center_location.state,
        icon: "http://www.google.com/mapfiles/arrow.png"
      });
    }
  },

  find : function(zip_code) {
    if (!zip_code.match(/\d{5}/)) {
      return;
    }
    Map.clear();
    Map.prepareMap();
    Map.data = [];
    Map.map.point = null;
    $.get("/labs/data?zip_code=" + zip_code, function(data) {
      if (!data.zip_location) {
        $('#event_list').append('<li>Sorry, Zip Code not Found</li>');
        return;
      }
      Map.data = data.labs;
        Map.map.point  = new google.maps.LatLng(data.zip_location.lat, data.zip_location.lng)
      Map.show();
    });
  },

  show : function(num) {
    num = num || Map.show_num;
    Map.clear();

    $.each(Map.data, function(index, lab) {
      if (index < num) {
        lab.image = Map.makeImage(index);
        lab.point = new google.maps.LatLng(lab.lat,lab.lng)
        Map.setMarker(lab);
        Map.createHtml(lab);
        Map.map.markerBounds.extend(lab.point);
      }
    });
    Map.map.view.fitBounds(Map.map.markerBounds);

    if (Map.data.length == 0) {
      $('#event_list').append('<li>Sorry, no Map Found</li>');
    } else if (Map.data.length > num) {
      $('#event_list_container p').show();
    }
  },

  setMarker : function(lab) {
    var marker = new google.maps.Marker({
      position: lab.point,
      map: Map.map.view,
      title: Map.tooltip_template(lab),
      icon: lab.image
    });
    return marker;
  },

  makeImage : function(index) {
    return "http://www.google.com/mapfiles/marker" + this.makeLetter(index) + ".png";
  },

  makeLetter : function(number) {
    if (number >= 0 && number <= 26) {
      return String.fromCharCode(number + 65);
    }
    return '';
  },

  createHtml : function(lab) {
    $('#event_list').append(this.details_template(lab));
  }

}

