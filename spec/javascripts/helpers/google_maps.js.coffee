window.google =
  maps: {}

window.google.maps.MapTypeId = {}
window.google.maps.MapTypeId.ROADMAP= 0

class window.google.maps.LatLng
  equals: (other)-> true

class DummyLatLng
  lat: -> 1
  lng: -> 1
  equals: (other)-> true

class window.google.maps.LatLngBounds
  constructor: ->
  getNorthEast: -> new DummyLatLng()
  equals: (other)-> true
  getSouthWest: -> new DummyLatLng()
  extend: (other) ->

class window.google.maps.Map
  fitBounds: ->

class window.google.maps.MarkerImage
  constructor: ->

class window.google.maps.Marker
  setIcon: (icon)->
